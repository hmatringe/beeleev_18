class AddCanPostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_post, :boolean, default: true
  end
end
