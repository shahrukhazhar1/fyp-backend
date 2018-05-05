# == Schema Information
#
# Table name: weekly_reports
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime
#  updated_at :datetime
#  device_id  :integer
#

class WeeklyReport < ActiveRecord::Base
  belongs_to :device
end
