class RemoveTargetedCountriesFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :targeted_countries
  end
end
