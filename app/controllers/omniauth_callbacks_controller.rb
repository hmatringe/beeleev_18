class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Callbacks
  ###########

  after_action(
    EmailTemplateSender.new('after-new-application', :@recipient),
    only: [:linkedin]
  )

  # Actions
  #########

  def linkedin
    # You need to implement the method below in your model
    # (e.g. app/models/user.rb)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.active?
      # this will throw if @user is not activated
      sign_in_and_redirect @user, event: :authentication

      if is_navigational_format?
        set_flash_message(:notice, :success, kind: 'LinkedIn')
      end
    elsif @user.activation_pending?
      # For Email template liquid variables
      @recipient = @user
      sign_in @user
      
      # redirect_to edit_account_path
      redirect_to onboarding_first_path
    else
      session['devise.linkedin_data'] = request.env['omniauth.auth']
      redirect_to root_path
    end
  end

  # Instance methods
  ##################

  def email_template_options
    {
      'user1' => @user
    }
  end
end
