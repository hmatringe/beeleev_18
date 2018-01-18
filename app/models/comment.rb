# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  body              :string(255)
#  author_id         :integer
#  beeleever_post_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Comment < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :author, class_name: 'User'
  belongs_to :beeleever_post

  delegate :name, to: :author, allow_nil: true, prefix: true

end
