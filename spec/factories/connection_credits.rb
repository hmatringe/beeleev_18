# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection_credit do
    user nil
    connection nil
    exprires_on "2015-06-29"
  end
end
