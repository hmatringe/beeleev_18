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
