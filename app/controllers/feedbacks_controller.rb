class FeedbacksController < ApplicationController

  layout false

  def new
    @resource = Feedback.new
    @resource.connection_id = params[:connection_id]
  end

  def create
    @resource = current_user.feedbacks.create params
      .require(:feedback)
      .permit!

    if @resource.save
      redirect_to account_path, notice: "Feedback submitted"
    else
      Rails.logger.debug @resource.errors.full_messages
      raise "unable to create feedback"
    end
  end

  def edit
    @resource = current_user.feedbacks.find params[:id]
  end

  def update
    @resource = current_user.feedbacks.find params[:id]
    @resource.attributes = params
      .require(:feedback)
      .permit!

    if @resource.save
      redirect_to account_path, notice: "Feedback updated"
    else
      Rails.logger.debug @resource.errors.full_messages
      raise "unable to update feedback"
    end

  end

end
