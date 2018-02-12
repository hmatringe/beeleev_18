class AddTargetedCountriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :targeted_countries, :text, array: true, default: []
  end
end
