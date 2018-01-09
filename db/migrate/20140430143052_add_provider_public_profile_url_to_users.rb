class AddProviderPublicProfileUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider_public_profile_url, :string
  end
end
