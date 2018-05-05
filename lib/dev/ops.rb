require 'open-uri'
require 'fileutils'

class Dev::Ops
  class << self
    def import_remote_uploads_for_resource!(item_name, items, names)
      errors = []
      imports = []

      items.each do |q|
        puts "importing #{item_name}: #{q.id}"

        item_errors = []
        item_imports = []

        names.each do |name|
          url = q.send(name + '_url')
          id = q.send(name + '_identifier')

          if !url.nil?
            begin
              dest = 'imports/remote/' + id
              FileUtils.mkdir_p(File.dirname(dest))
              remote = open(url)
              IO.copy_stream(remote, dest)
              item_imports << {
                name: name,
                path: dest,
                identifier: id
              }
            rescue => e
              item_errors << [name, e.message]
              puts "Error importing file: #{id}, #{e.message}"
            end
          end
        end

        if !item_errors.empty?
          errors << {
            id: q.id,
            errors: item_errors
          }
        end

        if !item_imports.empty?
          imports << {
            id: q.id,
            imports: item_imports
          }
        end
      end

      [errors, imports]
    end

    def quiz_upload_names
      [
        'attachment',
        'quiz_guide_attachment',
        'supplement_pdf_preview',
        'quiz_guide_pdf_preview'
      ]
    end

    def question_upload_names
      [
        'attachment',
        'study_guide_attachment',
        'question_guide_pdf_preview'
      ]
    end

    def answer_upload_names
      [
        'attachment',
      ]
    end

    def import_remote_uploads!
      quiz_errors, quiz_imports = * import_remote_uploads_for_resource!(
        'Quiz',
        Quiz.all,
        quiz_upload_names
      )

      question_errors, question_imports = * import_remote_uploads_for_resource!(
        'Question',
        Question.all,
        question_upload_names
      )

      answer_errors, answer_imports = * import_remote_uploads_for_resource!(
        'Answer',
        Answer.all,
        answer_upload_names
      )

      errors = {
        quizzes: quiz_errors,
        questions: question_errors,
        answers: answer_errors
      }

      imports = {
        quizzes: quiz_imports,
        questions: question_imports,
        answers: answer_imports
      }

      File.open("import-errors.json", "w") do |f|
        f.write(JSON.pretty_generate(errors))
      end

      File.open("import-items.json", "w") do |f|
        f.write(JSON.pretty_generate(imports))
      end

      # cleanup empty directories

      Dir['imports/remote/**/*'].select do |d|
        File.directory? d
      end.select do |d|
        (Dir.entries(d) - %w[ . .. ]).empty?
      end.each do |d|
        Dir.rmdir d
      end
    end

    def migrate_remote_uploads_for_resource!(resource, items)
      items.each do |item|
        r = resource.find(item['id'])
        puts "Migrating: #{resource.to_s}: #{r.id}"

        if r.nil?
          fail "#{resource.to_s}, #{item['id']} is nil"
        end

        item['imports'].each do |import|
          p = import['path']
          n = import['name']
          r.send(n + '=', File.open(p))
        end

        begin
          r.save!
        rescue => e
          puts "Error exporting: #{resource.to_s}: #{r.id}, #{e.message}"
        end
      end
    end

    def migrate_remote_uploads!
      cleanse_all_uploads!

      imports = JSON.parse(File.read('import-items.json'))

      migrate_remote_uploads_for_resource!(Quiz, imports['quizzes'])
      migrate_remote_uploads_for_resource!(Question, imports['questions'])
      migrate_remote_uploads_for_resource!(Answer, imports['answers'])
    end

    def cleanse_all_uploads_for_resource!(resource, names)
      resource.all.each do |r|
        puts "Cleansing: #{resource.to_s}: #{r.id}"

        names.each do |n|
          r.update_column(n, nil)
        end
      end
    end

    def cleanse_all_uploads!
      cleanse_all_uploads_for_resource!(Quiz, quiz_upload_names)
      cleanse_all_uploads_for_resource!(Question, question_upload_names)
      cleanse_all_uploads_for_resource!(Answer, answer_upload_names)
    end

    def remove_quiz_attribute_duplicates!
      names = Grade.pluck(:name).uniq
      names.each do |n|
        g1, *rst = * Grade.where(name: n)

        rst.each do |g2|
          g2.quiz_grades.update_all(grade_id: g1.id)
          g2.delete
        end
      end

      Quiz.all.each do |q|
        gids = q.quiz_grades.pluck(:grade_id).uniq
        q.quiz_grades = gids.map do |gid|
          QuizGrade.new(quiz_id: q.id, grade_id: gid)
        end
        q.save!
      end
    end

    def add_dml_permissions!
      sql1 = 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "cogli-db-user";'
      sql2 = 'GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "cogli-db-user";'
      ActiveRecord::Base.connection.execute(sql1)
      ActiveRecord::Base.connection.execute(sql2)
    end
  end
end
