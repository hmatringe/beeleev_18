class AccountsController < BeeleeverSpaceController
  before_action :set_user
  before_action :authorize_account_params, only: [:update,
                                                  :onboarding_first_update,
                                                  :onboarding_second_update,
                                                  :onboarding_third_update]
  before_action :validations_by_pass, only: [ :onboarding_first,
                                              :onboarding_first_update,
                                              :onboarding_second,
                                              :onboarding_second_update,
                                              :onboarding_third,
                                              :onboarding_third_update]


  def onboarding_first
  end

  def onboarding_first_update
    if @user.save
      redirect_to onboarding_second_path
    else
      flash.now[:alert] = @user.errors.full_messages.join('<br>').html_safe
      render :onboarding_first
    end
  end

  def onboarding_second
    @business_sectors = YAML.load (Rails.root + 'config/business_sectors.yml').read
  end
  
  def onboarding_second_update
    if @user.save
      redirect_to onboarding_third_path
    else
      flash.now[:alert] = @user.errors.full_messages.join('<br>').html_safe
      render :onboarding_second
    end
  end
  
  def onboarding_third
    @expertises = YAML.load (Rails.root + 'config/expertises.yml').read
  end

  def onboarding_third_update
    if @user.save
      redirect_to edit_account_path, notice: "Profile completed"
    else
      flash.now[:alert] = @user.errors.full_messages.join('<br>').html_safe
      render :onboarding_third
    end
  end
  
  def show    
      @orders = current_user.orders.order(created_at: :desc)
      @credits = current_user.connection_credits.order(created_at: :desc)
      @usable_credits = current_user.connection_credits.reject{|cc| !cc.usable?}

      @connections_history =
        current_user.user1_connections.history +
        current_user.user2_connections.history

      @connections_history = @connections_history.sort_by(&:created_at).reverse

      @connection_requests = current_user.connection_requests.order("created_at desc")

      @connection_credits = current_user.connection_credits.order(created_at: :desc)
  end

  def show_old
    @orders = current_user.orders.order(created_at: :desc)
    @credits = current_user.connection_credits.order(created_at: :desc)
  end

  def edit
  end

  def update
    if current_user.save
      redirect_to user_path(@user), notice: t("profile_updated")
    else
      flash.now[:alert] = @user.errors.full_messages.join('<br>').html_safe
      render :edit
    end
  end

  def destroy_account
    @user.delete_account
    sign_out @user
    redirect_to root_path, notice: "profile destroyed"
  end

  private 

  def set_user
    @user = current_user
  end

  def authorize_account_params
    @user.attributes = params.require(:user).permit!
  end

  def validations_by_pass
    @user.skip_civility_validation = '1'
    @user.skip_country_validation = '1'
    @user.skip_city_validation = '1'
    @user.skip_position_validation = '1'
    @user.skip_website_validation = '1'
    @user.skip_international_activity_countries_validation = '1'
    @user.skip_business_sectors_validation = '1'
    @user.skip_turnover_validation = '1'
    @user.skip_staff_volume_validation = '1'
  end
end
