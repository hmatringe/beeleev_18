class Coupon < ActiveRecord::Base

  def valid_for_user?(user)
    Time.zone.today < user.created_at + validity_duration.send(:month)
  end

end
