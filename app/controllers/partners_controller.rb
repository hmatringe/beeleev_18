class PartnersController < ApplicationController

  layout 'website'

  def index
    @partners = Partner.order(position: :asc).in_groups_of(3)
  end

  def index_18
    @partners = Partner.order(position: :asc).first(20).in_groups_of(5)
    @partners_categories = %w( premium expert incubation media )
  end

end
