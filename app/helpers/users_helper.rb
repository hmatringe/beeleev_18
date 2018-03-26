module UsersHelper

  def user_panel(user, version_18: false)
    actions = if current_user.connected_user_ids.include? user.id
      [:mailto, :contact_infos]
    else
      [:connect]
    end

    if version_18
      render "users/panel_18", user: user, actions: actions
    else
      render "users/panel", user: user, actions: actions
    end
  end

  def user_mailto_btn(user)
    link_to "mailto:#{user.email}", class: "btn btn-info btn-xs", data: {toggle: "tooltip"}, title: t('send_mail') do
      content_tag(:span, nil, class: "glyphicon glyphicon-envelope")
    end
  end

  def user_mailto_btn_18(user)
    link_to "mailto:#{user.email}", class: "card-button", target: "_blank", data: {toggle: "tooltip"}, title: "send email" do
      content_tag(:i, "", class: "fa fa-envelope-o")
    end
  end

  def user_contact_infos_btn(user)
    link_to "", class: "btn btn-success btn-xs toggle-user-contact-info-modal", data: {toggle: "tooltip"}, title: t("contact_infos") do
      content_tag(:span, nil, class: "glyphicon glyphicon-eye-open")
    end
  end

  def safe_truncate(user_attribute, size)
    if user_attribute
      user_attribute.truncate(size)
    end
  end

  def url_builder(url)
    if url.start_with? 'http'
      return url
    else
      return "http://#{url}"
    end
  end

end
