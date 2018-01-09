class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :title
      t.text  :subtitle
      t.string  :text
      t.text    :body
      t.string  :illustration
      t.boolean :published, default: false
      t.date    :publication_date, default: 'now()'

      t.timestamps
    end
  end
end
