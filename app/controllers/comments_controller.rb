class CommentsController < BeeleeverSpaceController
  def create
    respond_to do |format|
      format.js {

        @comment = Comment.new(params.require(:comment).permit(:body, :beeleever_post_id))
        @comment.author = current_user

        if @comment.save
        else
        end
      }
    end
  end
end
