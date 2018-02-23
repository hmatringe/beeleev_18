class HomeController < ApplicationController

  layout "website"

  def index
    active_users = User.active

    @beeleevers    = active_users.size
    @countries     = active_users.map(&:country).reject(&:blank?).uniq.size
    @nationalities = nationalities_count(active_users)
  end

  def home_18
    @navbar_type = "transparent"
    active_users = User.active

    @beeleevers    = active_users.size.round(-2) + 100
    @countries     = active_users.map(&:country).reject(&:blank?).uniq.size
    @nationalities = nationalities_count(active_users)

    @home = ""
    # @partners = Partner.order(position: :asc).first(6)
  end

  def components
  end

  def team
  end

  def team_18
  end

  def partners
  end

  private

  def nationalities_count(active_users)
    # The system currently allows duplicate like values for a User nationality
    # ex: "French", "Français", "Française", are counted as 3 different nationalities
    #
    # To temper this mecanical increase in nationalities count, we use here a reducing factor
    reducting_nationalities_factor = 3.0/5.0

    global_nationalies_count = active_users.map do |u|
      u.nationalite.strip.titleize if u.nationalite?
    end.compact.reject(&:blank?).uniq.size

    (global_nationalies_count.to_f * reducting_nationalities_factor).ceil
  end

end
