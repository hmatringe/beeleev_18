class PendingConnectionDemandsController < ApplicationController

  def update
    @cd = current_user.received_connection_demands.sent.find params[:id]

    case params[:commit]
    when "accept"
      @cd.accept!
      redirect_to account_path, notice: "Your are now connected with #{@cd.requester_name}"
    when "reject"
      @cd.reject!
      redirect_to account_path, alert: "Connection demand rejected"
    else
      redirect_to account_path, alert: "Invalid commit param"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to account_path, alert: "Invalid connection demand id"
  end

end
