require 'fcm'

task :seed_dev_env => :environment do
  Dev::Seeds.create_example_quiz!
end

task :create_question_attachment_quiz => :environment do
  Dev::Seeds.create_question_attachment_quiz!
end

task :add_quiz_result, [:device_id, :quiz_id, :correct, :wrong] => :environment do |t, args|
  Dev::Seeds.add_quiz_result_to_device!(args.to_hash)
end

task :add_plans => :environment do |t, args|
  Dev::Seeds.add_plans!
end

task :import_remote_uploads => :environment do
  Dev::Ops.import_remote_uploads!
end

task :migrate_remote_uploads => :environment do
  Dev::Ops.migrate_remote_uploads!
end

namespace :utils do
  desc 'Remove duplicates from quiz attributes'
  task :remove_quiz_attribute_duplicates => :environment do
    Dev::Ops.remove_quiz_attribute_duplicates!
  end

  desc 'Add DML permissions to SQL User'
  task :add_dml_permissions => :environment do
    Dev::Ops.add_dml_permissions!
  end

  desc 'Send push notification to device'
  task :send_push, [:device_id] => :environment do |task, args|
    device_id = args.device_id
    puts "Sending push notification to device with id = #{device_id}"
    device = Device.find_by_id(device_id)

    if device
      data = JSON.parse(STDIN.read)
      fcm = FCM.new(Cogli.fcm_api_key)

      registration_id = [device.fcm_token]
      options = {data: data, collapse_key: "push_notification"}
      begin
        puts fcm.send(registration_id, options)
      rescue => e
        raise e.message
      end
    end
  end
end
