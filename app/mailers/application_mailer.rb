class ApplicationMailer < ActionMailer::Base
  prod_domain = "cogli.herokuapp.com"

  default from: "no-reply@#{prod_domain}"
  layout 'mailer'
end
