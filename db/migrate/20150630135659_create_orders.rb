class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.integer :cents
      t.string :currency
      t.string :stripe_charge_id

      t.timestamps
    end
  end
end
