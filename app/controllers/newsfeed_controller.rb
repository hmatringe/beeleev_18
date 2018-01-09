class NewsfeedController < BeeleeverSpaceController

  def index
    @new_post = current_user.posts.build
    @posts = BeeleeverPost
      .page(1)
      .per(5)
      .order(created_at: :desc)
      .includes(comments: {author: {}})
  end

end
