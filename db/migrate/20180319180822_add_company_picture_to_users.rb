class AddCompanyPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_logo, :string
  end
end
