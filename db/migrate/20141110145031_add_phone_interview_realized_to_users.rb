class AddPhoneInterviewRealizedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_interview_realized, :boolean, default: false
    add_column :users, :new_application_reminder_count, :integer, default: 0
  end
end
