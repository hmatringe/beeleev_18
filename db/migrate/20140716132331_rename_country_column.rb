class RenameCountryColumn < ActiveRecord::Migration
  def change
    rename_column :users, :country_name, :country
  end
end
