module ConnectionCreditsHelper

  def connection_credit_expires_on(cc, format: :long)
    return 'never' unless cc.expires_on.present?
    ldate cc.expires_on, format: format
  end

  def connection_credit_details(cc)
    if cc.connection_id
      user2 = cc.connection.user2

      res = 'You have been connected to ' +
            link_to(user2.name, user2)

      res.html_safe
    elsif cc.expired?
      'This credit has expired and is not usable anymore'
    else
      'You can still use this credit to connect to other beeleevers'
    end
  end

end
