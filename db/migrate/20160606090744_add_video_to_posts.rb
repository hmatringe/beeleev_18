class AddVideoToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :embedded_video_tag, :text
  end
end
