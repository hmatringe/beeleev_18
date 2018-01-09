class CreateConnectionDemands < ActiveRecord::Migration
  def change
    create_table :connection_demands do |t|
      t.references :requester, index: true
      t.references :target, index: true
      t.text :description
      t.string :status
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
