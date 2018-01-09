class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :string

    User.reset_column_information

    reversible do |dir|
      dir.up do
        User.where(active: "Active").update_all(status: "active")
      end
    end

  end
end
