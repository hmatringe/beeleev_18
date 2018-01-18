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

require 'spec_helper'

describe Feedback do
  pending "add some examples to (or delete) #{__FILE__}"
end
