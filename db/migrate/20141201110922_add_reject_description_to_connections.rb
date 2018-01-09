class AddRejectDescriptionToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :reject_description, :text
  end
end
