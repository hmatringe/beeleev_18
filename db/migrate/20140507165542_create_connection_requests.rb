class CreateConnectionRequests < ActiveRecord::Migration
  def change
    create_table :connection_requests do |t|
      t.references :author, index: true
      t.string :subject
      t.text :countries
      t.text :activity_sector
      t.date :prefered_date_for_connection
      t.text :description

      t.timestamps
    end
  end
end
