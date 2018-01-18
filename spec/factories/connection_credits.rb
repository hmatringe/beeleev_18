# == Schema Information
#
# Table name: connection_credits
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  connection_id            :integer
#  expires_on               :date
#  created_at               :datetime
#  updated_at               :datetime
#  external                 :boolean
#  external_comments        :text
#  external_connection_date :date
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection_credit do
    user nil
    connection nil
    exprires_on "2015-06-29"
  end
end
