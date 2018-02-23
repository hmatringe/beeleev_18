module ConnectionDemandsHelper

  def new_connection_demand_btn(user2)

    # output an empty span if we are not allowed to see the button
    if cannot? :create, ConnectionDemand.new(user2_id: user2.id)
      return content_tag(
        :span, '&nbsp;',
        { style: 'display: inline-block; height: 22px;' }, false)
    end

    span = content_tag :span, t('connect'), class: 'glyphicon glyphicon-plus'

    link_to span, new_connection_demand_path(user2_id: user2.id),
            class: 'btn btn-success btn-xs',
            data: { toggle: 'modal', target: '#ajaxModal' }
  end

  # for legacy compatibility
  alias_method :user_connect_btn, :new_connection_demand_btn

  def new_connection_demand_btn_18(user2)

    # output an empty span if we are not allowed to see the button
    if cannot? :create, ConnectionDemand.new(user2_id: user2.id)
      return content_tag(
        :span, '&nbsp;',
        { style: 'display: inline-block; height: 22px;' }, false)
    end

    span = content_tag :span, "CONNECT"#, class: 'glyphicon glyphicon-plus'

    link_to span, new_connection_demand_path(user2_id: user2.id),
            class: 'card-button',
            data: { toggle: 'modal', target: '#ajaxModal' }
  end
end