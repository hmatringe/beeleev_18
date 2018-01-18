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

class ConnectionDemand < Connection

  include Reminders

  # Validations
  #############

  validates_presence_of :description

  # Callbacks
  ###########

  after_save :attach_connection_credit

  # State machine
  ###############

  aasm do
    initial_state :waiting_beeleev_response

    event :beeleev_accept do

      after do
        # Send an email to user1 and user2
        [1, 2].each do |i|
          sender = EmailTemplateSender.new(
            "after-beeleev-accept-connection-demand-to-user-#{i}",
            self.send("user#{i}")
          )
          sender.after(self)
        end
      end

      transitions from: :waiting_beeleev_response,
                  to: :waiting_user2_response,
                  on_transition: proc { |obj, *_args|
                    obj.update_attribute :beeleev_accepted_at, Time.now
                  }

    end
  end

  private

  def attach_connection_credit
    return unless (cc = user1.next_usable_connection_credit)
    cc.update_attribute :connection_id, id
  end

end
