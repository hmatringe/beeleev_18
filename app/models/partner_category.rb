# == Schema Information
#
# Table name: partner_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class PartnerCategory < ActiveRecord::Base
	has_many :partners
end
