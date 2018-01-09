require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# This task loops on users selected by the for_activate_user_reminder scope,
# sends the corresponding email template and increments
# activate_user_reminder_count by 1
#
desc 'Send activate_user reminder emails'
task send_activate_user_reminder_emails: [:environment] do |task|
  # use the tagged logger
  Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  Rails.logger.tagged(task.name.colorize(:green)) do
    # Loop on all selected users and calls the
    # :send_new_application_reminder_email method
    User.for_activate_user_reminder.each(
      &:send_activate_user_reminder_email
    )
  end
end

namespace :connections do
  desc 'send feedback reminders'
  task send_feedback_reminders: [:environment] do |task|

    # use the tagged logger
    Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    Rails.logger.tagged(task.name.colorize(:green)) do
      # Loop on all connections needing feedbackreminders and calls the
      # :send_feedback_reminders_emails method
      Connection.for_feedback_reminders.each do |connection|
        connection_string = "Connection #{connection.id}"
        Rails.logger.tagged(connection_string.colorize(:blue)) do
          connection.send_feedback_reminders_emails
        end
      end
    end
  end

end

namespace :connection_demands do
  desc 'send reminders to user2 to ask them to answer to a ConnectionDemand'
  task send_reminders: [:environment] do |task|

    # use the tagged logger
    Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

    Rails.logger.tagged(task.name.colorize(:green)) do
      # Loop on all ConnectionDemands needing a reminder and calls the
      # :send_reminders_emails method
      ConnectionDemand.for_reminders.each do |connection|
        connection_string = "ConnectionDemand #{connection.id}"
        Rails.logger.tagged(connection_string.colorize(:blue)) do
          connection.send_reminder_email
        end
      end
    end

  end
end
