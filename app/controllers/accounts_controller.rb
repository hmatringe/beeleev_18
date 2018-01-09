class AccountsController < BeeleeverSpaceController

  def show
    @orders = current_user.orders.order(created_at: :desc)
    @credits = current_user.connection_credits.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    current_user.attributes = params.require(:user).permit!

    if current_user.save
      redirect_to current_user, notice: t("profile_updated")
    else
      flash.now[:alert] = current_user.errors.full_messages.join('<br>').html_safe
      render :edit
    end
  end


end
