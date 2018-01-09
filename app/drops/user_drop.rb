class UserDrop < Liquid::Drop

  delegate :name, :first_name, :last_name, :application_reject_reason, {
    to: :object
  }

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def profile_url
    Rails.application.routes.url_helpers.user_url @object
  end

end
