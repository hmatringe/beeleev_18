module ConnectionRequestsHelper

  def new_connection_request_btn(classes: nil, btn_title: nil, tag_classes: nil, display_div: true)

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

    if classes
      title = btn_title
      html_options = {
        id: 'navbar-new-connection-request-btn',
        class: classes,
        data: data
      }
    else 
      title = 'smart connector'
      html_options = {
        id: 'navbar-new-connection-request-btn',
        class: 'btn btn-warning btn-xs navbar-btn',
        data: data
      }
    end


    link = link_to title, path, html_options
    if !display_div
      return link
    end
    content_tag :div, link, class: tag_classes
  end

end
