# encoding: utf-8

class DeviceAvatarUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  version :thumbnail do
    process :resize_to_fill=> [246, 246]
  end

  # NOTE: https://github.com/carrierwaveuploader/carrierwave/issues/1501
  def default_url(*args)
    'default_device_avatar.jpg'
  end

end
