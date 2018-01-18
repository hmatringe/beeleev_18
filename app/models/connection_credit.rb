# == Schema Information
#
# Table name: connection_credits
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  connection_id            :integer
#  expires_on               :date
#  created_at               :datetime
#  updated_at               :datetime
#  external                 :boolean
#  external_comments        :text
#  external_connection_date :date
#

class ConnectionCredit < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :user
  belongs_to :connection

  # Instance methods
  ##################

  # @return [Boolean]
  # Tells us if this ConnectionCredit is too old or not
  def expired?
    expires_on.present? && (expires_on < Time.zone.today)
  end

  # @return [Boolean]
  #
  # Checks if the ConnectionCredit is not expired and if it has not already been
  # used for a connection or for an external connection
  def usable?
    !expired? && connection_id.nil? && !external?
  end

end
