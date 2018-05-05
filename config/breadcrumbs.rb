crumb :root do
  link "Home", main_app.root_path
end

crumb :devices do
  link "Devices", main_app.devices_path
end

crumb :all_quizzes do
  link "All Quizzes", main_app.all_quizzes_path
end

# Index pages...
crumb :quizzes do |device|
  link device.name, main_app.device_quizzes_path(device, :q => {:s => 'priority ASC'})
  parent :devices
end

crumb :emergency_numbers do |device|
  link "Emergency Numbers of '#{device.name}'", main_app.device_emergency_numbers_path(device)
  parent :devices
end

crumb :questions do |quiz, quiz_selection|
  link quiz.name, main_app.device_quiz_path(quiz_selection.device, quiz)
  parent :quizzes, quiz_selection.device
end

crumb :answers do |quiz, quiz_selection, question|
  link question.text, main_app.device_quiz_question_path(quiz_selection.device, quiz, question)
  parent :questions, quiz, quiz_selection
end

# New and Edit pages...
crumb :new do |resource, *args|
  link "New #{resource.class.to_s.underscore.humanize}", '#'
  parent *args
end

crumb :edit do |resource, *args|
  link "Edit '#{resource.to_s.truncate(20, omission: '...')}'", '#'
  parent *args
end

crumb :choose_quizzes do |device|
  link 'Choose Quizzes', '#'
  parent :quizzes, device
end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
