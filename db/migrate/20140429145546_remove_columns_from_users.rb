class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :title
    remove_column :users, :company_name
    remove_column :users, :company_website
    remove_column :users, :company_creation_year
    remove_column :users, :company_turnover
    remove_column :users, :company_growth_rate
    remove_column :users, :business_countries, array: true
  end
end
