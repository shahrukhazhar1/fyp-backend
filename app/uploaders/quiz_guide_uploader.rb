class QuizGuideUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave
	def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(pdf doc htm html docx png jpeg)
  end
end
