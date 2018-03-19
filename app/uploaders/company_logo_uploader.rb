class CompanyLogoUploader < BeeleevUploader

  process :resize_to_fit => [200, 200]

  # Versions
  ##########

  version :navbar do
    process :resize_to_fill => [22, 22]
  end

  version :panel do
    process :resize_to_fit => [80, 80]
  end

  # Instance methods
  ##################

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url

    # A processor is an array of 3 values
    # - processor_name (ie: :resize_to_fill)
    # - arguments (ie: [22,22])
    # - I don't know what the 3rd value corresponds to
    #
    # let's get the first processors's arguments and extract the width of it
    width = processors.first[1][0]

    "https://res.cloudinary.com/hfnojcdpy/image/upload/c_scale,w_#{width}/v1398789973/company_icon_etymz3.png"
  end
end
