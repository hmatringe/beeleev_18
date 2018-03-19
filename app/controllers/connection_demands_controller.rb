class ConnectionDemandsController < ApplicationController

  # Actions
  #########

  def new
    @resource = ConnectionDemand.new user1: current_user, user2_id: params[:user2_id]
    render layout: false
  end

  def show
    @resource = ConnectionDemand.find params[:id]
    render layout: false
  end

  def create

    @connection_demand = current_user.sent_connection_demands.build(params
      .require(:connection_demand)
      .permit(:user2_id, :description)
    )

    if @connection_demand.save
      redirect_to network_path
    else
      redirect_to network_path, alert: 'Problem when trying to create connection demand'
    end
  end

  def update
    @cd = current_user.received_connection_demands.waiting_user2_response.find params[:id]

    case params[:commit]
    when 'user2_accept'
      @cd.user2_accept!
      redirect_to account_path, notice: "Your are now connected with #{@cd.user1_name}"
    when 'user2_reject'
      # update the reject_description
      @cd.update_attributes(
        params.require(:connection_demand).permit(:reject_description)
      )

      @cd.user2_reject!

      redirect_to account_path, alert: 'Connection demand rejected'
    else
      redirect_to account_path, alert: 'Invalid commit param'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to account_path, alert: 'Invalid connection demand id'
  end

  # Instance methods
  ##################

  def email_template_options
    @connection_demand.email_template_options
  end

end
