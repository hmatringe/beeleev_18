class RemoveOldUserAttributes < ActiveRecord::Migration
  def change
    remove_column :users, :creation_date, :date
  end
end
