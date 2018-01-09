class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :title
      t.string :company_name
      t.string :company_website
      t.integer :company_creation_year
      t.decimal :company_turnover
      t.float :company_growth_rate
      t.string :business_countries, array: true

      t.timestamps
    end
  end
end
