class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :author, index: true
      t.references :connection, index: true
      t.string :contacted
      t.integer :quality_of_qualification
      t.integer :quality_of_contact
      t.string :prolific_contact
      t.string :met
      t.boolean :would_you_recommend
      t.text :description

      t.timestamps
    end
  end
end
