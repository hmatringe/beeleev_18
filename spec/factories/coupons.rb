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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "MyString"
    discount_percentage 1
    validity_duration 1
  end
end
