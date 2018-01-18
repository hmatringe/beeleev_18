# == Schema Information
#
# Table name: connections
#
#  id                                :integer          not null, primary key
#  user1_id                          :integer
#  user2_id                          :integer
#  created_at                        :datetime
#  updated_at                        :datetime
#  type                              :string(255)
#  status                            :string(255)
#  description                       :text
#  reject_description                :text
#  send_feedback_reminders           :boolean          default(TRUE)
#  send_feedback_reminders_after     :date
#  feedback_reminders_count          :integer          default(0)
#  beeleev_accepted_at               :datetime
#  beeleev_rejected_at               :datetime
#  user1_accepted_at                 :datetime
#  user1_rejected_at                 :datetime
#  user2_accepted_at                 :datetime
#  user2_rejected_at                 :datetime
#  connection_demand_reminders_count :integer          default(0)
#

class Connection < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"

  has_one :connection_credit, dependent: :nullify

  # Constants
  ###########

  HISTORY_STATUSES = %w(rejected_by_user1 rejected_by_user2 live)

  # Class methods
  ###############

  class << self

    def connect(user1, user2)
      user1.user1_connections.create user2: user2
      user2.user1_connections.create user2: user1
    end

    def disconnect(user1, user2)
      user1.user1_connections.find_by_user2_id(user2.id).try :destroy
      user2.user1_connections.find_by_user2_id(user1.id).try :destroy
    end

    def history
      where(status: HISTORY_STATUSES)
    end

  end

  # State machine
  ###############

  include AASM

  aasm column: :status do
    state :waiting_beeleev_response
    state :rejected_by_beeleev
    state :waiting_user1_response
    state :rejected_by_user1
    state :waiting_user2_response
    state :rejected_by_user2
    state :live

    event :beeleev_reject do
      transitions from: :waiting_beeleev_response, to: :rejected_by_beeleev

      after do
        sender = EmailTemplateSender.new(
          "after-beeleev-reject-connection-demand", self.user1
        )
        sender.after(self)
      end
    end

    event :user1_reject do
      transitions from: :waiting_user1_response, to: :rejected_by_user1
    end

    event :user2_reject do
      transitions from: :waiting_user2_response, to: :rejected_by_user2

      after do
        sender = EmailTemplateSender.new(
          "after-user2-reject-connection", self.user1
        )
        sender.after(self)
      end
    end

    event :user2_accept do
      transitions from: :waiting_user2_response, to: :live

      after do
        update_attribute :user2_accepted_at, Time.zone.now

        sender = EmailTemplateSender.new(
          "after-user2-accept-connection", [self.user1, self.user2]
        )
        sender.after(self)
      end
    end

  end

  include Feedbacks
  include FeedbackReminders

  # Instance methods
  ##################

  delegate :name, to: :user1, prefix: true
  delegate :name, to: :user2, prefix: true

  def display_name
    [user1.try(:name), 'to', user2.try(:name)].join ' '
  end

  def history?
    HISTORY_STATUSES.map {|status| send "#{status}?"}.any? {|e| e == true}
  end

  def to_liquid
    ConnectionDrop.new self
  end

  def answer_url
    Rails.application.routes.url_helpers.activity_url(
      anchor: "answer-for-connection-#{id}"
    )
  end

  def email_template_options
    {
      'user1'      => user1,
      'user2'      => user2,
      'connection' => self,
      'answer_url' => answer_url
    }
  end

end
