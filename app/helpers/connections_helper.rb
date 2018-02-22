module ConnectionsHelper

  def connection_link_to_user(resource)

    user = if current_user == resource.user1
      resource.user2
    else
      resource.user1
    end

    user.first_name == "unavailable" ? user.name : link_to(user.name, user)
  end

  def connection_display_type(resource)
    resource.class.model_name.human.gsub('Connection ', '')
  end

  def connection_link_to_see(resource)

    css = %w(btn btn-xs)

    if resource.history?
      name = "See".upcase
      css << 'btn-bleu-fonce'
    else
      name = 'Answer'.upcase
      css << 'btn-warning'
    end

    link_to name,
      self.send(resource.class.to_s.underscore + "_path", resource),
      class: css.join(' '),
      data: {toggle: "modal", target: "#ajaxModal"}

  end

  def connection_feedback(resource)
    if current_user == resource.user1
      resource.user1_feedback
    else
      resource.user2_feedback
    end
  end

  def connection_link_to_feedback(resource)

    path = if feedback = connection_feedback(resource)
      edit_feedback_path feedback
    else
      new_feedback_path(connection_id: resource.id)
    end

    link_to 'Feedback'.upcase,
      path,
      class: "btn btn-success btn-xs",
      data: {toggle: "modal", target: "#ajaxModal"}

  end

  def connection_row(resource)
    render "connections/row", resource: resource
  end

  def connection_display_profil(resource)
    user = if current_user == resource.user1
      resource.user2
    else
      resource.user1
    end

    user.profil
  end

end
