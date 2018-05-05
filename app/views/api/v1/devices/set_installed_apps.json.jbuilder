json.device do |json|
  json.id               @device.id
  json.name             @device.name
  json.device_id        @device.device_id
  json.avatar           @device.avatar.present? ? @device.avatar.thumbnail.to_s : ActionController::Base.helpers.image_url(@device.avatar.thumbnail.to_s)
  json.created_at       @device.created_at
  json.updated_at       @device.updated_at
  json.fcm_token  @device.fcm_token.to_s
  json.quizzes @device.quizzes do |quiz|
    json.id         quiz.id
    json.name       quiz.name
    json.subject    quiz.subject
    json.grades      quiz.grades.collect(&:name)
    json.passing_percentage quiz.passing_percentage
    
    # json.supplement_pdf quiz.attachment_url.to_s
    # json.supplement_text quiz.supplement_text
    # json.quiz_guide_text quiz.quiz_guide
    # json.quiz_guide_url quiz.quiz_guide_attachment_url.to_s

    json.quiz_guide_attachment_url  quiz.quiz_guide_attachment.try(:url)
    json.quiz_guide  quiz.quiz_guide
    json.quiz_guide_attachment_preview  quiz.quiz_guide_pdf_preview.try(:url)
    json.supplement_pdf_preview  quiz.supplement_pdf_preview.url
    json.supplement_filename  quiz.supplement_filename
    json.guide_filename  quiz.guide_filename

    json.questions quiz.questions do |question|
      json.id       question.id
      json.text     question.text
      json.hint     question.hint
      json.comment  question.comment
      json.latex    question.latex
      json.attachment_url question.attachment.url.to_s
      json.study_guide_attachment question.study_guide_attachment.url.to_s
      json.study_guide_text question.study_guide
      json.answers question.answers do |answer|
        json.id       answer.id
        json.text     answer.text
        json.correct  answer.correct
        json.latex    answer.latex
      end
    end
  end
  json.emergency_numbers @device.emergency_numbers do |emergency_number|
    json.name emergency_number.name
    json.phone_number emergency_number.phone_number
  end
  json.install_apps @device.install_apps do |app|
    json.app_name app.app_name
    json.package_name app.package_name
    json.block_status app.block_status
  end
end
