class CityAutocomplete

  constructor: (input, options) ->
    @city         = null
    @input        = input
    @options      = options
    @autocomplete = new google.maps.places.Autocomplete @input[0], @options

    @autocomplete.addListener 'place_changed', this.placeChanged.bind(this)

  placeChanged: () ->
    @place = @autocomplete.getPlace()
    this.setCityValue()

  setCityValue: ->
    if @place.address_components?
      @city = @place.address_components[0].long_name
    else
      @city = null

    @input.val(@city)

$(document).on 'ready page:load', ->

  if $('#user_city').size() == 1
    ca = new CityAutocomplete $('#user_city'), {types: ['(cities)']};
