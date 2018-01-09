class RemovePreferedDateForConnectionOnConnectionRequests < ActiveRecord::Migration
  def change
    remove_column :connection_requests, :prefered_date_for_connection
  end
end
