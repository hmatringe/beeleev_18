class MultipleBusinessSectorsForRequests < ActiveRecord::Migration
  def change
    add_column :connection_requests,
               :business_sectors,
               :text,
               array: true,
               default: []

    ConnectionRequest.find_each do |cr|
      cr.update_column :business_sectors, "\{#{cr.activity_sector}\}"
    end

    remove_column :connection_requests,
                  :activity_sector,
                  :text
  end
end
