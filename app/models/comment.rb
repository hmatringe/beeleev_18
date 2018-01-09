class Comment < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :author, class_name: 'User'
  belongs_to :beeleever_post

  delegate :name, to: :author, allow_nil: true, prefix: true

end
