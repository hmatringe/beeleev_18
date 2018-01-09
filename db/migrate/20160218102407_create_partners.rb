class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :url
      t.string :image
      t.string :title
      t.text :body
      t.integer :position

      t.timestamps
    end
  end
end
