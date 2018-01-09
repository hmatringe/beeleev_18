class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :user1, index: true
      t.references :user2, index: true

      t.timestamps
    end

    add_index :connections, [:user2_id, :user1_id], unique: true
    add_index :connections, [:user1_id, :user2_id], unique: true
  end
end
