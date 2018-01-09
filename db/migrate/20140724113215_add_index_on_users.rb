class AddIndexOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :expertises, using: 'gin'
  end
end
