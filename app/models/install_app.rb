# == Schema Information
#
# Table name: install_apps
#
#  id           :integer          not null, primary key
#  app_name     :string
#  package_name :string
#  device_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  block_status :boolean          default(FALSE)
#  device_udid  :string
#

class InstallApp < ActiveRecord::Base
  belongs_to :device
end
