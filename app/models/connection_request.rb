class ConnectionRequest < ActiveRecord::Base

  # Callbacks
  ###########

  before_save :_remove_blank_from_business_sectors

  # Associations
  ##############

  belongs_to :author, class_name: "User"

  # State machine
  ###############

  include AASM

  aasm column: :status do
    state :waiting_beeleev_response, :initial => true
    state :processed
  end

  # Instance methods
  ##################

  delegate :name, to: :author, prefix: true

  def display_name
    [author_name, subject].join(' - ')
  end

  private

  def _remove_blank_from_business_sectors
    business_sectors.reject!(&:blank?)
  end
end
