class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production? && !ENV["LIVE"]
    http_basic_authenticate_with :name => "beeleev", :password => "beeleev"
  end

  @navbar_type = "white"

  private

  # def current_user; User.find 244; end
  def default_url_options
    { host: ENV["HOST"] || "localhost:3000" }
  end

end
