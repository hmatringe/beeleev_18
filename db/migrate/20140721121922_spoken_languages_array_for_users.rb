class SpokenLanguagesArrayForUsers < ActiveRecord::Migration
  def change
    remove_column :users, :language
    add_column :users, :spoken_languages, :string, array: true
  end
end
