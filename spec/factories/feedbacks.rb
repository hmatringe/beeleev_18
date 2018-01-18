# == Schema Information
#
# Table name: feedbacks
#
#  id                       :integer          not null, primary key
#  author_id                :integer
#  connection_id            :integer
#  contacted                :string(255)
#  quality_of_qualification :integer
#  quality_of_contact       :integer
#  prolific_contact         :string(255)
#  met                      :string(255)
#  would_you_recommend      :boolean
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#

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
