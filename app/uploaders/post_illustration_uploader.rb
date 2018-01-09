class PostIllustrationUploader < BeeleevUploader

  process :resize_to_limit => [555, nil]

  # Versions
  ##########

  version :thumbnail do
    process :resize_to_fill => [100, 63]
  end

  # Instance methods
  ##################

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    # TODO : use holder js here
    # "holder.js/300x200"
  end

end
