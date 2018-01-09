class AddConnectionDemandRemindersCountToConnections < ActiveRecord::Migration
  def change
    add_column :connections,
               :connection_demand_reminders_count,
               :integer,
               default: 0
  end
end
