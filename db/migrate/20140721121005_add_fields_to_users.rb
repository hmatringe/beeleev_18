class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :twitter_account, :string
    add_column :users, :skype_account, :string
  end
end
