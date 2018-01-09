class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount_percentage
      t.integer :validity_duration

      t.timestamps
    end
  end
end
