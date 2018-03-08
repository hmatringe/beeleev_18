class BeeleevUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
