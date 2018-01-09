class ExpertisesForUsers < ActiveRecord::Migration
  def change
    add_column :users, :expertises, :string, array: true
  end
end
