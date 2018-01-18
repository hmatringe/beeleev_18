# == Schema Information
#
# Table name: coupons
#
#  id                  :integer          not null, primary key
#  code                :string(255)
#  discount_percentage :integer
#  validity_duration   :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Coupon < ActiveRecord::Base

  def valid_for_user?(user)
    Time.zone.today < user.created_at + validity_duration.send(:month)
  end

end
