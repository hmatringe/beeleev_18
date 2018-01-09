class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_date, :date
    add_column :users, :week, :integer
    add_column :users, :active, :string
    add_column :users, :sponsor, :string
    add_column :users, :source, :string
    add_column :users, :profil, :string
    add_column :users, :prospects, :string
    add_column :users, :civility, :string
    add_column :users, :nationalite, :string
    add_column :users, :city, :string
    add_column :users, :country_name, :string
    add_column :users, :language, :string
    add_column :users, :cellphone, :string
    add_column :users, :position, :string
    add_column :users, :company, :string
    add_column :users, :activities_1, :text
    add_column :users, :activities_2, :text
    add_column :users, :creation_date, :date
    add_column :users, :turnover, :string
    add_column :users, :staff_volume, :string
    add_column :users, :website, :string
    add_column :users, :url_profile, :string
    add_column :users, :meeting_form, :string
  end
end
