class AddTargetAndCityToConnectionRequests < ActiveRecord::Migration
  def change
  	add_column :connection_requests, :targets, :text, array: true, default: []
  	add_column :connection_requests, :city, :text
  end
end
