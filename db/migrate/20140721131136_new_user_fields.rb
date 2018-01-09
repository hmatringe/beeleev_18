class NewUserFields < ActiveRecord::Migration
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :entrepreneur_clubs, :string
    add_column :users, :investment_activity, :boolean
    add_column :users, :year_of_creation, :string
    add_column :users, :business_sector, :string
    add_column :users, :description, :text
    add_column :users, :tagline, :string
    add_column :users, :business_model, :string
    add_column :users, :international_activity, :boolean
    add_column :users, :international_activity_countries, :text, array: true
    add_column :users, :growth_rate, :string
    add_column :users, :current_customers, :text
    add_column :users, :current_partners, :text
    add_column :users, :hiring_objectives, :boolean
    add_column :users, :investment_level, :string
  end
end
