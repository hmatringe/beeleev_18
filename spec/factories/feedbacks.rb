# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    author nil
    connection nil
    contacted "MyString"
    quality_of_qualification 1
    quality_of_contact 1
    prolific_contact "MyString"
    met "MyString"
    would_you_recommand false
    description "MyText"
  end
end
