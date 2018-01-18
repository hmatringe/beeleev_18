# == Schema Information
#
# Table name: feedbacks
#
#  id                       :integer          not null, primary key
#  author_id                :integer
#  connection_id            :integer
#  contacted                :string(255)
#  quality_of_qualification :integer
#  quality_of_contact       :integer
#  prolific_contact         :string(255)
#  met                      :string(255)
#  would_you_recommend      :boolean
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#

class Feedback < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :author, class_name: "User"
  belongs_to :connection

  # Validations
  #############

  validates_presence_of :author_id
  validates_presence_of :connection_id
  validates_presence_of :contacted
  # validates_presence_of :quality_of_qualification
  # validates_presence_of :quality_of_contact
  validates_presence_of :prolific_contact
  validates_presence_of :met

end
