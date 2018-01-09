class Partner < ActiveRecord::Base

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
