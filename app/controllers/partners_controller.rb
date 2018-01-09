class PartnersController < ApplicationController

  layout 'website'

  def index
    @partners = Partner.order(position: :asc).in_groups_of(3)
  end

end
