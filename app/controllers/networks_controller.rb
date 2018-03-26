class NetworksController < BeeleeverSpaceController

  before_action :setup_search
  before_action :setup_countries
  before_action :setup_cities
  before_action :setup_profiles
  before_action :set_pagination

  # def show_original
  #   authorize! :access_network, current_user
  #   @users = users_scope.page(params[:page]).per(24)
  # rescue CanCan::AccessDenied
  #   redirect_to edit_account_path
  # end

  def show
    authorize! :access_network, current_user
    @users = users_scope.page(params[:page]).per(@pagination)
  rescue CanCan::AccessDenied
    redirect_to edit_account_path
  end

  # def search
  #   @users = @q.result.page(params[:page]).per(@pagination)
  #   render :show
  # end

  def search_any
    @users = @q.result.page(params[:page]).per(@pagination)
    render :show
  end

  def search_one
    @users = @q.result.page(params[:page]).per(@pagination)
    render :show
  end

  protected

  def users_scope
    User
      .active
      .ordered_by_name
      .where("id != :id", id: current_user.id)
  end

  # Do the actual ransack search
  def setup_search
    @q = users_scope.search params[:q]
  end

  def setup_countries
    @countries = User.active.pluck(:country)
                 .uniq.compact.reject(&:blank?)
                 .sort
  end

  def setup_cities
    @cities = User.active.pluck(:city)
                 .uniq.compact.reject(&:blank?)
                 .sort
  end

  def setup_profiles
    @profiles = ['Entrepreneur', 'Local Partner', 'Expert']
  end
  
  def set_pagination
    @pagination = 24
  end

end
