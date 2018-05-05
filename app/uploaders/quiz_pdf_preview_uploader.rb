class QuizPdfPreviewUploader < CarrierWave::Uploader::Base
  storage :gcloud

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(png jpeg jpg)
  end

  # So this one is odd, but in order to migrate
  # we need to skip checking removable
  # def remove!
  #   puts 'Skipping remove...'
  # end
end
