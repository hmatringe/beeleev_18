class AddCompanyDescriptionToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :company_description, :string, default: ""
  end
end
