task :send_email => :environment do
  prod_domain = "portal.cogliapp.com"

  users = User.all
  users ||=[]
  users.each do |user|
    if user.devices.present?
      none_sent = true

      user.devices.each do |device|
        quiz_results =  device.quiz_results.recent
        if quiz_results.present?
          weekly_report = device.weekly_reports.create(start_date: Time.now - 7.days, end_date: Time.now)

          puts "Creating weekly report for user:[#{user.email}], device:[#{device.id}]"

          if Rails.env.production?
            report_url = "https://#{prod_domain}/weekly_reports/#{weekly_report.id}"
            unsubscribe_url = "https://#{prod_domain}/user_settings/#{device.user.id}/unsubscribe"
          else
            report_url = "http://localhost:5000/weekly_reports/#{weekly_report.id}"
            unsubscribe_url = "http://localhost:5000/user_settings/#{device.user.id}/unsubscribe"
          end

          if device.user.send_email.present? && device.send_mail
            puts "Sending email for weekly report for user:[#{user.email}], device:[#{device.id}]"
            none_sent = false
            SendEmails.sendit(device.user.email,"Cogli - Weekly Progress Report - #{device.name}",report_url,device.name,device.user.username,unsubscribe_url).deliver!
          end
        end
      end

      if none_sent &&
          !user.devices.empty? &&
          user.devices.all? {|d| d.subscription == nil }

        puts "Sending email for inactive user:[#{user.email}]"

        if Rails.env.production?
          unsubscribe_url = "https://#{prod_domain}/user_settings/#{user.id}/unsubscribe"
        else
          unsubscribe_url = "http://localhost:5000/user_settings/#{user.id}/unsubscribe"
        end

        SendEmails.noactivity(
          user.email,
          "Cogli - No Activity",
          user.username,
          unsubscribe_url
        ).deliver!
      end
    end
  end
end
