ActiveAdmin.register Country do

  menu false

  # /admin/countries/:country_name/cities.json
  member_action :cities, :method => :get do

    # We use the CountrySelect.countries hash here because it containes
    # localized names for countries.
    #
    # Most notably, the "US" country's name is "United States" be we receive in
    # params[:id] "United States of America"
    country_pair = CountrySelect.countries.detect do |kv|
      kv.last == params[:id]
    end
    country_code = country_pair.first

    # Get the country object from the country code
    country = Country.search country_code

    # get an array of Cities::City objects
    cities = country.cities.values

    # find all city names that start with params[:q], case insensitive
    matching_cities = cities.find_all do |city|
      city.name =~ /^#{params[:q]}/i
    end

    render json: matching_cities
  end

end
