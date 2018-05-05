class SendEmails < ApplicationMailer
  # default :from => 'no-reply@' + 'cogli.com'
  def sendit(email,subject,message,device_name,username,unsubscribe_url)
    @msg = message
    @device_name = device_name
    @username = username
    @unsubscribe_url = unsubscribe_url
    mail( :to => email,:subject => subject, from: "Cogli <no-reply@cogli.com>" )
  end

  def send_notif(email,subject,message)
    @msg = message
    mail(to: email, subject: subject, from: "Cogli <no-reply@cogli.com>" )
  end

  def noactivity(email, subject, username, unsubscribe_url)
    @username = username
    @unsubscribe_url = unsubscribe_url
    mail( :to => email, :subject => subject, from: "Cogli <no-reply@cogli.com>" )
  end
end
