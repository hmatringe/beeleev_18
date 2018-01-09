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
