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
      redirect_to current_user, notice: "Profile completed"
    else
      flash.now[:alert] = @user.errors.full_messages.join('<br>').html_safe
      render :onboarding_third
    end
  end

  def update
    if current_user.save
      redirect_to current_user, notice: t("profile_updated")
    else
      flash.now[:alert] = current_user.errors.full_messages.join('<br>').html_safe
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

  # def anonymise_attributes
  #   @user.delete_account

  #   @user.first_name = "unavailable"
  #   @user.last_name =  ""
  #   @user.email =  "#{rand(1.0...100000.0)}@unavailable.com"
  #   @user.provider =  ""
  #   @user.uid =  ""
  #   @user.remove_avatar = true
  #   @user.week =  ""
  #   @user.sponsor =  ""
  #   @user.source =  ""
  #   @user.profil =  "-"
  #   @user.prospects =  ""
  #   @user.civility =  ""
  #   @user.nationalite =  ""
  #   @user.city =  ""
  #   @user.country =  ""
  #   @user.cellphone =  ""
  #   @user.position =  ""
  #   @user.company =  ""
  #   @user.activities_1 =  ""
  #   @user.activities_2 =  ""
  #   @user.turnover =  ""
  #   @user.staff_volume =  ""
  #   @user.website =  ""
  #   @user.url_profile =  ""
  #   @user.meeting_form =  ""
  #   @user.provider_public_profile_url =  nil #LinkedIn
  #   @user.password =  "1234554321"
  #   @user.phone =  ""
  #   @user.twitter_account =  nil
  #   @user.skype_account =  nil
  #   @user.spoken_languages =  []
  #   @user.expertises =  []
  #   @user.date_of_birth =  ""
  #   @user.entrepreneur_clubs =  ""
  #   @user.investment_activity =  false
  #   @user.year_of_creation =  ""
  #   @user.description =  ""
  #   @user.tagline =  ""
  #   @user.business_model =  ""
  #   @user.international_activity =  false
  #   @user.international_activity_countries =  []
  #   @user.growth_rate =  ""
  #   @user.current_customers =  ""
  #   @user.current_partners =  ""
  #   @user.hiring_objectives =  false
  #   @user.phone_interview_realized =  false
  #   @user.new_application_reminder_count =  0
  #   @user.application_reject_reason =  ""
  #   @user.business_sectors =  []
  #   @user.investment_levels =  []
  #   @user.targeted_countries =  []
  #   @user.company_description =  ""
  #   @user.facebook_username =  nil
  # end

end
