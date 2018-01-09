class UsersController < BeeleeverSpaceController

  def show
    @user = User.find params[:id]
  end

end
