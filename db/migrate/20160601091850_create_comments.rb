class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.references :author, index: true
      t.references :beeleever_post, index: true
      t.timestamps
    end
  end
end
