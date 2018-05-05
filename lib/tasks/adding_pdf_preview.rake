task :set_pdf_preview => :environment do
  
  quizzes = Quiz.all
  quizzes ||=[]
  
  quizzes.each do |quiz|

    if quiz.attachment.present? && quiz.attachment.url.present?
      url = quiz.attachment.url
      quiz.supplement_filename ||= create_filename(url)
      quiz.supplement_pdf_preview ||= create_preview(url)
      quiz.save
    end

    if quiz.quiz_guide_attachment.present? && quiz.quiz_guide_attachment.url.present?
      url = quiz.quiz_guide_attachment.url
      quiz.guide_filename ||= create_filename(url)
      quiz.quiz_guide_pdf_preview ||= create_preview(url)
      quiz.save
    end
    if quiz.questions.present?
      questions = quiz.questions
      questions.each do |question|
        if question.study_guide_attachment_url.present?
          url = question.study_guide_attachment_url
          question.guide_filename ||= create_filename(url)
          question.question_guide_pdf_preview = create_preview(url) unless question.question_guide_pdf_preview_url.present?
          question.save(validate:false)
        end

      end
    end
  end
end


def create_preview(url)
  pdf = Magick::ImageList.new(url)
  thumb = pdf.scale(300, 300)
  temp_file = Tempfile.new([ 'temp', '.png' ])
  thumb.write(temp_file.path)
  temp_file 
end

def create_filename(url)
  name = url.split('upload')[1].split('/').last.split('.pdf').last
end