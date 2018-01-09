class PartnerImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def public_id
    id = model.id || (model.class.last.id + 1)
    "partners/#{id}"
  end

end
