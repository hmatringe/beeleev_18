# == Schema Information
#
# Table name: users
#
#  id                               :integer          not null, primary key
#  first_name                       :string(255)
#  last_name                        :string(255)
#  email                            :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#  provider                         :string(255)
#  uid                              :string(255)
#  avatar                           :string(255)
#  created_date                     :date
#  week                             :integer
#  active                           :string(255)
#  sponsor                          :string(255)
#  source                           :string(255)
#  profil                           :string(255)
#  prospects                        :string(255)
#  civility                         :string(255)
#  nationalite                      :string(255)
#  city                             :string(255)
#  country                          :string(255)
#  cellphone                        :string(255)
#  position                         :string(255)
#  company                          :string(255)
#  activities_1                     :text
#  activities_2                     :text
#  turnover                         :string(255)
#  staff_volume                     :string(255)
#  website                          :string(255)
#  url_profile                      :string(255)
#  meeting_form                     :string(255)
#  status                           :string(255)
#  provider_public_profile_url      :string(255)
#  encrypted_password               :string(255)      default(""), not null
#  reset_password_token             :string(255)
#  reset_password_sent_at           :datetime
#  remember_created_at              :datetime
#  phone                            :string(255)
#  twitter_account                  :string(255)
#  skype_account                    :string(255)
#  spoken_languages                 :string(255)      default([]), is an Array
#  expertises                       :string(255)      default([]), is an Array
#  date_of_birth                    :date
#  entrepreneur_clubs               :string(255)
#  investment_activity              :boolean
#  year_of_creation                 :string(255)
#  description                      :text
#  tagline                          :string(255)
#  business_model                   :string(255)
#  international_activity           :boolean
#  international_activity_countries :text             default([]), is an Array
#  growth_rate                      :string(255)
#  current_customers                :text
#  current_partners                 :text
#  hiring_objectives                :boolean
#  phone_interview_realized         :boolean          default(FALSE)
#  new_application_reminder_count   :integer          default(0)
#  application_reject_reason        :text
#  business_sectors                 :string(255)      default([]), is an Array
#  investment_levels                :string(255)      default([]), is an Array
#  activate_user_reminder_count     :integer          default(0)
#  activated_at                     :datetime
#  stripe_customer_id               :string(255)
#  can_post                         :boolean          default(TRUE)
#  company_description              :string(255)      default("")
#  facebook_username                :string(255)      default("")
#

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
