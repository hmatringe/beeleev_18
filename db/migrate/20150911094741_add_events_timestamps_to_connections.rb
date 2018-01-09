class AddEventsTimestampsToConnections < ActiveRecord::Migration
  def change
    change_table :connections do |t|
      t.datetime :beeleev_accepted_at
      t.datetime :beeleev_rejected_at
      t.datetime :user1_accepted_at
      t.datetime :user1_rejected_at
      t.datetime :user2_accepted_at
      t.datetime :user2_rejected_at
    end
  end
end
