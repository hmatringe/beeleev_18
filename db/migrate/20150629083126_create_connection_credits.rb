class CreateConnectionCredits < ActiveRecord::Migration
  def change
    create_table :connection_credits do |t|
      t.references :user, index: true
      t.references :connection, index: true
      t.date :expires_on

      t.timestamps
    end
  end
end
