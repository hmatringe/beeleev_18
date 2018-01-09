module ConnectionRequestsHelper

  def new_connection_request_btn

    return nil if cannot?(:see_new_connection_request_button, current_user)

    path, data =
      if can? :create, ConnectionRequest
        [new_connection_request_path, toggle: 'modal', target: '#ajaxModal']
      else
        [
          '',
          {
            toggle: 'modal',
            target: '#noCreditsModal'
          }
        ]
      end

    html_options = {
      id: 'navbar-new-connection-request-btn',
      class: 'btn btn-warning btn-xs navbar-btn',
      data: data
    }

    link = link_to 'smart connector', path, html_options
    content_tag :div, link
  end

end
