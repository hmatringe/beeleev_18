class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, only: [
                                                  :not_found,
                                                  :unacceptable,
                                                  :internal_server_error
                                                ]
  layout "website"

  def not_found
    render status: 404
  end

  def unacceptable
    render status: 422
  end

  def internal_server_error
    render status: 500
  end

end