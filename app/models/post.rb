# == Schema Information
#
# Table name: posts
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  subtitle           :text
#  text               :string(255)
#  body               :text
#  illustration       :string(255)
#  published          :boolean          default(FALSE)
#  publication_date   :date             default(Mon, 22 Dec 2014)
#  created_at         :datetime
#  updated_at         :datetime
#  detailed_body      :text
#  type               :string(255)
#  author_id          :integer
#  embedded_video_tag :text
#

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
