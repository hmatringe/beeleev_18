#= require active_admin/base
'#= require select2/select2.min'
#= require active_admin_select2/active_admin_select2
#= require admin/index-sortable.js

select2ForCities = false

$ ->
  $('#connection_request_business_sectors').select2
    width: 'element'
    placeholder: "Select business sectors"

  $('#user_country').select2
    width: 'element'
    placeholder: "Select a country"

  # initialize the city select2 if a country is already selected
  if select2ForCities
    initCitySelect2() if $('#user_country').val() != null

  # The city select2 must be reinitialized every time the country changes
  $('#user_country').change ->
    $('#user_city').val(null)
    initCitySelect2() if select2ForCities

  $('
    #user_spoken_languages,
    #user_business_sector,
    #user_expertises,
    #user_business_model,
    #user_international_activity_countries,
    #user_turnover,
    #user_staff_volume,
    #user_business_sectors
  ').select2
    width: 'element'

  $('#user_investment_levels').select2
    width: '400px'

initCitySelect2 = ->
  # Setup the select2
  $('#user_city').select2
    width: "240px"
    placeholder: "Select a city"
    minimumInputLength: 3
    allowClear: true
    id: (city) ->
      city.data.accentcity
    ajax:
      url: "/admin/countries/" + $('#user_country').val() + "/cities.json"
      dataType: 'json'
      data: (term, page) ->
        object =
          q: term
        object
      results: (data, page) ->
        results: data
    initSelection: (element, callback) ->
      id = $(element).val()
      object = data:
        accentcity: id
      callback object
    formatResult: (data) ->
      "<div class='select2-user-result'>" + data.data.accentcity + "</div>";
    formatSelection: (data) ->
      data.data.accentcity
