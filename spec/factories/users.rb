# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    title "MyString"
    company_name "MyString"
    company_website "MyString"
    company_creation_year 1
    company_turnover "9.99"
    company_growth_rate 1.5
    business_countries "MyString"
  end
end
