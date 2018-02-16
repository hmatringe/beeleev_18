class NetworksController < BeeleeverSpaceController

  before_action :setup_search
  before_action :setup_countries
  before_action :setup_profiles

  # def show_original
  #   authorize! :access_network, current_user
  #   @users = users_scope.page(params[:page]).per(24)
  # rescue CanCan::AccessDenied
  #   redirect_to edit_account_path
  # end

  def show
    authorize! :access_network, current_user
    @users = users_scope.page(params[:page]).per(3)
    # @users = User.none
  rescue CanCan::AccessDenied
    redirect_to edit_account_path
  end

  # def search
  #   @users = @q.result.page(params[:page]).per(24)
  #   render :show
  # end

  def search_any
    @users = @q.result.page(params[:page]).per(24)
    render :show
  end

  def search_one
    @users = @q.result.page(params[:page]).per(24)
    render :show
  end



  protected

  def users_scope
    User
      .active
      .ordered_by_name
  end

  # Do the actual ransack search
  def setup_search
    @q = users_scope.search params[:q]
    # raise
  end

  def setup_countries
    @countries = User.active.pluck(:country)
                 .uniq.compact.reject(&:blank?)
                 .sort
  end
  def setup_profiles
    @profiles = User.active.pluck(:profil)
                 .uniq.compact.reject(&:blank?)
                 .sort
  end

end
