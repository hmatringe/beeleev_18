class AddCompanySoMeAccountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_twitter_account, :string
    add_column :users, :company_facebook_account, :string
    add_column :users, :company_linkedin_account, :string
  end
end
