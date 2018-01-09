class RenameEmailTemplate10 < ActiveRecord::Migration
  def change
    EmailTemplate.find(10).update_attribute \
      :name, 'after-activate-user-reminder-1'

    EmailTemplate.destroy [11, 12]

    add_column :users, :activate_user_reminder_count, :integer, default: 0

    # Make sure the already active users will not be selected for future
    # reminders
    User.active.update_all activate_user_reminder_count: 1
  end
end
