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

require 'spec_helper'

describe ConnectionCredit do
  pending "add some examples to (or delete) #{__FILE__}"
end
