class AddStiToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :type, :string
    Post.update_all type: 'EventPost'
  end
end
