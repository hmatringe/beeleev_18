class AddApplicationRejectReasonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :application_reject_reason, :text
  end
end
