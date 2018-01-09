class Connection
  module FeedbackReminders

    extend ActiveSupport::Concern

    # Constants
    ###########

    # Number of days after which the first feedback reminder should be sent
    FIRST_FEEDBACK_REMINDER_INTERVAL =
      (ENV["FIRST_FEEDBACK_REMINDER_INTERVAL"].try :to_i) || 14

    # Number of days that separate each feedback reminder email
    FEEDBACK_REMINDERS_INTERVAL =
      (ENV["FEEDBACK_REMINDERS_INTERVAL"].try :to_i) || 7

    # Each user of this connection will not receive more than
    # MAX_FEEDBACK_REMINDERS emails
    MAX_FEEDBACK_REMINDERS =
      (ENV["MAX_FEEDBACK_REMINDERS"].try :to_i) || 3

    included do

      # AASM additions
      ################

      # Add a new lambda for the :after callback on the :user2_accept event
      # to update the connection's send_feedback_reminders_after date
      user2_accept_event = aasm.events[:user2_accept]

      user2_accept_event.options[:after] << lambda {
        self.update_attribute :send_feedback_reminders_after,
          Time.zone.today + FIRST_FEEDBACK_REMINDER_INTERVAL
      }

    end

    # Class methods
    ###############

    module ClassMethods

      # Selects :
      #
      # - live connections
      # - with send_feedback_reminders attribute == true
      # - with send_feedback_reminders_after date before today
      # - with at least a feedback missing
      # - with feedback_reminders_count < MAX_FEEDBACK_REMINDERS
      #
      # @return [Array] an array of collection records
      def for_feedback_reminders
        t = arel_table

        eligible =
          where(send_feedback_reminders: true).
          where(t[:send_feedback_reminders_after].lt(Time.zone.today)).
          where(t[:feedback_reminders_count].lt(MAX_FEEDBACK_REMINDERS)).
          live.
          includes(:feedbacks)

        eligible.find_all(&:feedback_missing?)
      end

    end

    # Instance methods
    ##################

    # Array of FeedbackReminder objects
    #
    # @return [Array]
    def feedback_reminders

      feedback_reminders = []

      unless user1_feedback
        feedback_reminders << FeedbackReminder.new(self, user1, user2)
      end

      unless user2_feedback
        feedback_reminders << FeedbackReminder.new(self, user2, user1)
      end

      feedback_reminders
    end

    # Send the necessary feedback reminder emails, shift the
    # send_feedback_reminders_after date FEEDBACK_REMINDERS_INTERVAL days in
    # the future and increments the feedback_reminders_count counter.
    def send_feedback_reminders_emails
      # Send the emails
      feedback_reminders.each do |fr|
        fr.send_feedback_reminder_email
      end

      # Shift the send_feedback_reminders_after date of
      # FEEDBACK_REMINDERS_INTERVAL seconds in the future
      self.send_feedback_reminders_after =
        Time.zone.today + FEEDBACK_REMINDERS_INTERVAL

      # Increment feedback_reminders_count
      self.feedback_reminders_count += 1

      # save the connection
      save
    end

  end
end
