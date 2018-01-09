class ConnectionDemandsController < ApplicationController

  # Callbacks
  ###########

  after_action(
    EmailTemplateSender.new('after-new-connection-demand', :@recipient),
    only: [:create]
  )

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
      @recipient = @connection_demand.user1
      redirect_to network_path, notice: 'Beeleev will review your connection demand soon'
    else
      redirect_to network_path, alert: 'Problem when trying to create connection demand'
    end
  end

  def update
    @cd = current_user.received_connection_demands.waiting_user2_response.find params[:id]

    case params[:commit]
    when 'user2_accept'
      @cd.user2_accept!
      redirect_to activity_path, notice: "Your are now connected with #{@cd.user1_name}"
    when 'user2_reject'
      # update the reject_description
      @cd.update_attributes(
        params.require(:connection_demand).permit(:reject_description)
      )

      @cd.user2_reject!

      redirect_to activity_path, alert: 'Connection demand rejected'
    else
      redirect_to activity_path, alert: 'Invalid commit param'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to activity_path, alert: 'Invalid connection demand id'
  end

  # Instance methods
  ##################

  def email_template_options
    @connection_demand.email_template_options
  end

end
