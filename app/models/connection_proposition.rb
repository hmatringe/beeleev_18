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

class ConnectionProposition < Connection

  # Validations
  #############

  validate :ensure_usable_connection_credit, \
           on: :create, if: :should_consume_a_credit?

  # Callbacks
  ###########

  after_save on: :create do
    user1.next_usable_connection_credit.update_attribute \
      :connection_id, id \
      if should_consume_a_credit?
  end

  after_commit on: :create do
    send_email_template(
      'connection-proposition-waiting-user1-response',
      user1
    )
  end

  # State machine
  ###############

  aasm do
    initial_state :waiting_user1_response

    event :user_1_accept do

      after do
        sender = EmailTemplateSender.new(
          'after-user1-accept-connection-proposition',
          user2
        )
        sender.after(self)
      end

      transitions from: :waiting_user1_response, to: :waiting_user2_response
    end
  end

  # Attributes
  ############

  attr_accessor :consume_credit

  # Private methods
  #################

  private

  def should_consume_a_credit?
    consume_credit == '1'
  end

  def ensure_usable_connection_credit
    unless user1.next_usable_connection_credit
      errors.add(:consume_credit, "#{user1.name} does not have usable credits")
    end
  end

end
