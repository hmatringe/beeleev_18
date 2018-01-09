# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection_proposition do
    for_user nil
    proposed_user nil
    description "MyText"
    status "MyString"
  end
end
