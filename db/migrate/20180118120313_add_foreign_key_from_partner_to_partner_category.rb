class AddForeignKeyFromPartnerToPartnerCategory < ActiveRecord::Migration
  def change
  	add_column :partners, :partner_category_id, :integer
  	add_foreign_key :partners, :partner_categories
  end
end
