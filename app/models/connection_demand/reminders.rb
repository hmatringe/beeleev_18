class ConnectionDemand
  module Reminders

    extend ActiveSupport::Concern

    # Constants
    ###########

    # Number of days after which the first reminder should be sent
    FIRST_REMINDER_INTERVAL =
      (ENV['FIRST_CONNECTION_DEMAND_REMINDER_INTERVAL'].try :to_i) || 7

    # Number of days that separate each reminder email
    SECOND_REMINDER_INTERVAL =
      (ENV['SECOND_CONNECTION_DEMAND_REMINDER_INTERVAL'].try :to_i) || 14

    # Class methods
    ###############

    module ClassMethods

      def for_reminders
        [for_first_reminder, for_second_reminder].flatten
      end

      # Selects :
      #
      # - waiting_user2_response connections
      # - with beeleev_accepted_at old enough
      #     (see ConnectionDemand::FIRST_REMINDER_INTERVAL)
      # - with connection_demand_reminders_count == 0
      #
      # @return [Array] an array of ConnectionDemand records
      def for_first_reminder
        t = arel_table

        waiting_user2_response
          .where(
            t[:beeleev_accepted_at]
            .lt(Time.zone.today - ConnectionDemand::FIRST_REMINDER_INTERVAL))
          .where(
            t[:connection_demand_reminders_count]
            .eq(0)
          )
      end

      # Selects :
      #
      # - waiting_user2_response connections
      # - with beeleev_accepted_at old enough
      #     (see ConnectionDemand::SECOND_REMINDER_INTERVAL)
      # - with connection_demand_reminders_count == 0
      #
      # @return [Array] an array of ConnectionDemand records
      def for_second_reminder
        t = arel_table

        waiting_user2_response
          .where(
            t[:beeleev_accepted_at]
            .lt(Time.zone.today - ConnectionDemand::SECOND_REMINDER_INTERVAL))
          .where(
            t[:connection_demand_reminders_count]
            .eq(1)
          )
      end

    end

    # Instance methods
    ##################

    # Send the necessary reminder emails, shift the
    # send_feedback_reminders_after date FEEDBACK_REMINDERS_INTERVAL days in
    # the future and increments the feedback_reminders_count counter.
    def send_reminder_email

      sender = EmailTemplateSender.new(
        _reminder_template_name,
        user2
      )

      sender.after(self)

      # Increment feedback_reminders_count
      self.connection_demand_reminders_count += 1

      # save the connection
      save
    end
  end

  private

  def _reminder_index
    connection_demand_reminders_count + 1
  end

  def _reminder_template_name
    "after-beeleev-accept-connection-demand-reminder-#{_reminder_index}"
  end
end
