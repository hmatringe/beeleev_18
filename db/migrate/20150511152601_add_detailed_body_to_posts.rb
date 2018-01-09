class AddDetailedBodyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :detailed_body, :text
  end
end
