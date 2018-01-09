module UsersHelper

  def user_panel(user)

    actions = if current_user.connected_user_ids.include? user.id
      [:mailto, :contact_infos]
    else
      [:connect]
    end

    render "users/panel", user: user, actions: actions
  end

  def user_mailto_btn(user)
    link_to "mailto:#{user.email}", class: "btn btn-info btn-xs", data: {toggle: "tooltip"}, title: t('send_mail') do
      content_tag(:span, nil, class: "glyphicon glyphicon-envelope")
    end

  end

  def user_contact_infos_btn(user)
    link_to "", class: "btn btn-success btn-xs toggle-user-contact-info-modal", data: {toggle: "tooltip"}, title: t("contact_infos") do
      content_tag(:span, nil, class: "glyphicon glyphicon-eye-open")
      # t("contact_infos")
    end
  end

end
