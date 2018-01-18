# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  amount               :integer
#  currency             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  statement_descriptor :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    title "MyString"
    description "MyText"
    amount 1
    currency "MyString"
  end
end
