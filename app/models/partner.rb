# == Schema Information
#
# Table name: partners
#
#  id                  :integer          not null, primary key
#  url                 :string(255)
#  image               :string(255)
#  title               :string(255)
#  body                :text
#  position            :integer
#  created_at          :datetime
#  updated_at          :datetime
#  partner_category_id :integer
#

class Partner < ActiveRecord::Base

  belongs_to :partner_category
  # Callbacks
  ###########

  before_create :_set_position

  mount_uploader :image, PartnerImageUploader

  # Private methods
  #################

  private

  def _set_position
    last_position = self.class.maximum(:position) || 0
    self.position = last_position + 1
  end

end
