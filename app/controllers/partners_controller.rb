class PartnersController < ApplicationController

  layout 'website'

  def index
    @partners = Partner.order(position: :asc).in_groups_of(3)
  end

  def index_18
    @partners_categories = PartnerCategory.order(position: :asc)
  end

end
