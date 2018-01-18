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

require 'spec_helper'

describe Coupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
