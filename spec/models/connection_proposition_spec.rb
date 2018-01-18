# == Schema Information
#
# Table name: connections
#
#  id                                :integer          not null, primary key
#  user1_id                          :integer
#  user2_id                          :integer
#  created_at                        :datetime
#  updated_at                        :datetime
#  type                              :string(255)
#  status                            :string(255)
#  description                       :text
#  reject_description                :text
#  send_feedback_reminders           :boolean          default(TRUE)
#  send_feedback_reminders_after     :date
#  feedback_reminders_count          :integer          default(0)
#  beeleev_accepted_at               :datetime
#  beeleev_rejected_at               :datetime
#  user1_accepted_at                 :datetime
#  user1_rejected_at                 :datetime
#  user2_accepted_at                 :datetime
#  user2_rejected_at                 :datetime
#  connection_demand_reminders_count :integer          default(0)
#

require 'spec_helper'

describe ConnectionProposition do
  pending "add some examples to (or delete) #{__FILE__}"
end
