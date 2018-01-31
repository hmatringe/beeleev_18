class Users::SessionsController < Devise::SessionsController

  # layout "website"

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    # if the request is an XHR, render the template without any template
    # since it is destined to go inside a Boostrap modal
    #
    # if the entire /users/sign_in page was requested, most certainly because of
    # an authentication failure redirection, then redirect again to the
    # root_path with the "sign_in" anchor to permit toggling the sign_in modal
    # via JS
    if request.xhr?
      render layout: false
    else
      redirect_to root_path(anchor: "sign_in")
    end

  end

end
