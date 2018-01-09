class ConnectionRequestsController < ApplicationController

  # Constants
  ###########

  UNAUTHORIZED_MESSAGE =  'You must buy credits before sending us '\
                          'a connection request'

  # Filters
  #########

  before_filter :ensure_xhr, only: [:new, :edit]

  # Actions
  #########

  def new
    render text: UNAUTHORIZED_MESSAGE and return \
      unless can? :create, ConnectionRequest

    @cr = current_user.connection_requests.build
    render layout: false
  end

  def edit
    @cr = current_user.connection_requests.find params[:id]
    render layout: false
  end

  def create
    redirect_to shop_path, notice: UNAUTHORIZED_MESSAGE and return \
      unless can? :create, ConnectionRequest

    @cr = current_user.connection_requests
          .build params
          .require(:connection_request)
          .permit(:subject, :countries, :description, business_sectors: [])

    if @cr.save
      redirect_to shop_path(anchor: 'activate-package'), notice: 'Your connection request has been sent'
    else
      redirect_to shop_path, alert: 'Unable to send connection request'
    end
  end

  def update
    @cr = current_user.connection_requests.find params[:id]

    @cr.update_attributes params
      .require(:connection_request)
      .permit(:subject, :countries, :description, business_sectors: [])

    if @cr.save
      redirect_to activity_path, notice: 'Your connection request has been updated'
    else
      redirect_to activity_path, alert: 'Unable to update connection request'
    end

  end

  private

  def ensure_xhr
    redirect_to shop_path(anchor: 'new_connection_request') and return \
      unless request.xhr?
  end

  def ensure_can_create_connection_request
    render text: 'You must buy credits before sending us a connection request' \
      and return unless can? :create, ConnectionRequest
  end

end
