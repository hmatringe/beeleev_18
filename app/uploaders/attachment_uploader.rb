class AttachmentUploader < BeeleevUploader

  # Instance methods
  ##################

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
  end

  # WARNING : this must only be used with Cloudinary in prod
  def public_id
    Cloudinary::PreloadedFile.split_format(original_filename).first +
      '_' +
      Cloudinary::Utils.random_public_id[0, 6]
  end

end
