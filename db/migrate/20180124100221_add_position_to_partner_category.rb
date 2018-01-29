class AddPositionToPartnerCategory < ActiveRecord::Migration
  def change
    add_column :partner_categories, :position, :integer
  end
end
