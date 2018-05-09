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
    json.questions quiz.questions do |question|
      json.id       question.id
      json.text     question.text
      json.hint     question.hint
      json.latex    question.latex
      json.attachment_url question.attachment.url.to_s
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
