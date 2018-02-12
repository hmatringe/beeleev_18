class UsersController < BeeleeverSpaceController

  def show
    user = User.find params[:id]
    @user = user.decorate
  end

  def show_old
    @user = User.find params[:id]
  end

end
