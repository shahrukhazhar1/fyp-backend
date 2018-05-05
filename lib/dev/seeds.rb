class Dev::Seeds
  class << self
    def example_quiz
      Quiz.new({
        name: "example quiz",
        subject: "SAT Math",
        topic: "Math",
        test_prep: "SAT Math",
        description: "Example Quiz Description",
        passing_percentage: 95,
        status: :approved,
        quiz_status: "approved",
        questions: example_questions,
        quiz_grades: example_quiz_grades
      })
    end

    def example_questions
      20.times.map do |_|
        Question.new({
          text: "Example Question",
          answers: example_answers
        })
      end
    end

    def example_answers
      answers = 3.times.map do |_|
        Answer.new({
          text: "Example Wrong Answer",
          correct: false
        })
      end

      answers << Answer.new({
        text: "Example Correct Answer",
        correct: true
      })
    end

    def example_quiz_grades
      3.times.map do |i|
        QuizGrade.new({
          grade: example_grade(i+5)
        })
      end
    end

    def example_grade(i)
      Grade.where(
        name: "#{i.ordinalize} Grade",
        priority: i
      ).first_or_initialize
    end

    def create_example_quiz!
      q = example_quiz
      q.save!
      q.quiz_status = "approved"
      q.name += ": #{q.id}"
      q.save!
    end

    def create_question_attachment_quiz!
      q = example_quiz
      qq = q.questions.first
      qq.remote_attachment_url = 'http://res.cloudinary.com/ddixjy0jk/image/upload/v1499744203/mcsbcnjqgk3rsbcv3iso.png'
      q.questions = [qq]
      q.save!
      q.quiz_status = "approved"
      q.name += ": #{q.id}"
      q.save!
    end

    def add_quiz_result_to_device!(params)
      [:correct, :wrong, :quiz_id, :device_id].each do |k|
        params.fetch(k)
      end

      qs = QuizSelection.where({
        quiz_id: params[:quiz_id],
        device_id: params[:device_id]
      }).first

      if qs.nil?
        qs = QuizSelection.new({
          quiz_id: params[:quiz_id],
          device_id: params[:device_id]
        })

        qs.save!
      end

      params[:quiz_selection_id] = qs.id
      params.delete(:quiz_id)
      params[:correct] = Integer(params[:correct]).times.to_a
      params[:wrong] = Integer(params[:wrong]).times.to_a

      q = QuizResult.new(params)
      q.save!
    end

    def add_plans!
      Plan.create!({
        name: 'Monthly',
        price: 10.99,
        interval: 'month',
        stripe_id: '1',
        features: ['Billed Monthly'].join("\n\n"),
        display_order: 1
      })

      Plan.create!({
        name: 'Semi Annual',
        price: 9.99,
        interval: 'month',
        stripe_id: '1',
        features: ['Billed Semi-Annually'].join("\n\n"),
        display_order: 2
      })

      Plan.create!({
        name: 'Annual',
        price: 8.99,
        interval: 'month',
        stripe_id: '1',
        features: ['Billed Annually'].join("\n\n"),
        display_order: 3
      })
    end
  end
end
