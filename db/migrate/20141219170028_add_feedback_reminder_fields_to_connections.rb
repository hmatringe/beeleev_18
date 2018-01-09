class AddFeedbackReminderFieldsToConnections < ActiveRecord::Migration
  def change

    # Should we send feedback reminders for this connection
    add_column :connections, :send_feedback_reminders, :boolean, default: true

    # A date before which we should not send feedback reminders
    add_column :connections, :send_feedback_reminders_after, :date

    # an integer that stores how many times we have sent the feedback reminders
    # for this connection
    add_column :connections, :feedback_reminders_count, :integer, default: 0
  end
end
