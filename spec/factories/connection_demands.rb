# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection_demand do
    requester nil
    target nil
    description "MyText"
  end
end
