class MyNetworksController < BeeleeverSpaceController

  before_action :authenticate_user!

  def show
    authorize! :access_network, current_user

    @users = current_user.connected_users
      .active
      .ordered_by_name
      .page(params[:page]).per(24)
  rescue CanCan::AccessDenied
    redirect_to edit_account_path
  end


end
