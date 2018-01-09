class Post < ActiveRecord::Base

  mount_uploader :illustration, PostIllustrationUploader

  scope :published, -> {
    where published: true
  }

  scope :non_published, -> {
    where published: false
  }

  # Associations
  ##############

  belongs_to :author, class_name: 'User'

end
