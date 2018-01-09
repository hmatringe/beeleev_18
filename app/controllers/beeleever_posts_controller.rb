class BeeleeverPostsController < BeeleeverSpaceController

  def index
    respond_to do |format|
      format.js {
        @posts = BeeleeverPost
          .page(params[:page])
          .per(5)
          .order(created_at: :desc)
      }
    end
  end

  def create
    respond_to do |format|

      permitted_params = [:body, :illustration]
      permitted_params << :embedded_video_tag if can? :share, 'Video'

      format.js {
        @post = current_user.posts.build(
          params
            .require(:beeleever_post)
            .permit(permitted_params)
        )

        if @post.save
        else
          flash[:alert] = 'Something went wrong when saving your post.'
          render 'newsfeed'
        end
      }
    end
  end

end
