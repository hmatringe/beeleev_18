class ConnectionRequestsController < ApplicationController

  # Constants
  ###########

  UNAUTHORIZED_MESSAGE =  'You must buy credits before sending us '\
                          'a connection request'

  TARGETS = { "An Entrepreneur" => 1,
              "A Company or an Expert" => 2,
              "An International Group" => 4}

  # Filters
  #########

  before_filter :ensure_xhr, only: [:new, :edit]
  before_action :set_targets, only: [:new, :edit]

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
    redirect_to direct_request_path, notice: UNAUTHORIZED_MESSAGE and return \
      unless can? :create, ConnectionRequest
    
    @cr = current_user.connection_requests
          .build formatted_params
          .require(:connection_request)
          .permit(:subject, :countries, :description, :city, business_sectors: [], targets: [])

    if @cr.save
      redirect_to direct_request_path(anchor: 'activate-package'), notice: 'Your Direct Request has been sent to our teams. We will contact you within 24 working hours to detail your requirement further. Keep an eye on your mailbox!'
    else
      redirect_to direct_request_path, alert: 'Unable to send Direct Request'
    end
  end

  def update
    @cr = current_user.connection_requests.find params[:id]

    @cr.update_attributes formatted_params
      .require(:connection_request)
      .permit(:subject, :countries, :description, :city, business_sectors: [], targets: [])

    if @cr.save
      redirect_to account_path, notice: 'Your Direct Request has been updated'
    else
      redirect_to account_path, alert: 'Unable to update Direct Request'
    end
  end

  private

  def ensure_xhr
    redirect_to direct_request_path(anchor: 'new_connection_request') and return \
      unless request.xhr?
  end

  def ensure_can_create_connection_request
    render text: 'You must buy credits before sending us a connection request' \
      and return unless can? :create, ConnectionRequest
  end

  def set_targets
    @targets = TARGETS
  end

  def formatted_params
    if params[:connection_request][:targets]
      params[:connection_request][:targets] = [params[:connection_request][:targets]]
    end
    params
  end
end
