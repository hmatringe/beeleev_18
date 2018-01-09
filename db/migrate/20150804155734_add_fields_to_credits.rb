class AddFieldsToCredits < ActiveRecord::Migration
  def change
    add_column :connection_credits, :external, :boolean
    add_column :connection_credits, :external_comments, :text
    add_column :connection_credits, :external_connection_date, :date
  end
end
