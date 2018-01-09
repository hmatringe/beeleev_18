class AddStatusToConnectionRequests < ActiveRecord::Migration
  def change
    add_column :connection_requests, :status, :string
    ConnectionRequest.update_all status: "waiting_beeleev_response"
  end
end
