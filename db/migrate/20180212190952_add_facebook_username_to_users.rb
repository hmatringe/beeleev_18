class AddFacebookUsernameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :facebook_username, :string, default: ""
  end
end
