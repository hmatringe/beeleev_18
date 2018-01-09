class CreateConnectionPropositions < ActiveRecord::Migration
  def change
    create_table :connection_propositions do |t|
      t.references :for_user, index: true
      t.references :proposed_user, index: true
      t.references :admin_user, index: true
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
