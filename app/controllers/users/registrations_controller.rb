class Users::RegistrationsController < Devise::RegistrationsController

  # Callbacks
  ###########

  after_action(
    EmailTemplateSender.new("after-new-application", :@user1),
    only: [:create]
  )

  # Actions
  #########

  def new
    build_resource({})
    render layout: false
  end

  def create

    @user = User.new params
      .require(:user)
      .permit(
        :first_name, :last_name, :email, :position, :company,
        :password, :password_confirmation, :country
      )

    @user.profil = "Entrepreneur"

    if @user.save
      # For Email template liquid variables
      @user1 = @user

      sign_in @user
      redirect_to edit_account_path
    else
      redirect_to root_path, alert: "Could not save user"
    end

  end

end

