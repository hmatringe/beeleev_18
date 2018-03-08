#= require jquery
#= require jquery_ujs
#= require turbolinks

#= require modernizr/modernizr
#= require bootstrap
#= require bootstrap3-datepicker/js/bootstrap-datepicker
#= require bootstrap3-datepicker/js/locales/bootstrap-datepicker.fr

#= require cloudinary
#= require social_plugins
#= require flashes_fade
#= require disable_enter_form

#= require select2/select2.min
#= require sign_up

#= require_tree ./front

setupNetworkSearchSelect2 = ->
  $(
    '#q_country_in,
    #q_city_in,
    #q_city_eq:not([readonly]),
    #q_expertises_overlap,
    #q_business_sectors_overlap,
    #q_international_activity_countries_overlap'
  ).select2
    width: 'element'

shouldOpenNewConnectionRequestModal = ->
  window.location.hash == "#new_connection_request"

openNewConnectionRequestModal = ->
  $("#navbar-new-connection-request-btn").click()

connectionIdForFeedbackModal = ->
  try
    [result, connectionId] = window.location.hash.match(/^#feedback-for-connection-(\d+)/)
    connectionId
  catch TypeError
    null

connectionIdForAnswerConnectionModal = ->
  try
    [result, connectionId] = window.location.hash.match(/^#answer-for-connection-(\d+)/)
    connectionId
  catch TypeError
    null

openFeedbackModal = (connectionId) ->
  $("[href='/feedbacks/new?connection_id=#{connectionId}']").click()

openAnswerConnectionModal = (connectionId) ->
  $("[href^='/connection_'][href$='#{connectionId}']").click()

$(document).on 'ready page:load', ->
  openNewConnectionRequestModal() if shouldOpenNewConnectionRequestModal()
  openFeedbackModal connectionIdForFeedbackModal()
  openAnswerConnectionModal connectionIdForAnswerConnectionModal()

  $('[data-toggle="tooltip"]').tooltip()

  $(".modal-ajax").on 'hidden.bs.modal', (e) ->
    $(@).data 'bs.modal', null

    if href = $(e.target).data('remote')
      $(e.target).modal
        remote: href
      $(e.target).data 'remote', null

  $(document).on 'click', '[data-toggle="reopen-modal"]', ->
    $('.modal-ajax').data('remote', $(@).attr('href'))
    $('.modal-ajax').modal('hide')
    false

  
  

  $('#q_city_eq').on 'change', ->
    @.form.submit()

  $('#user_country').select2()
  $('#user_civility').select2()

  $('
    #user_business_sector,
    #user_expertises,
    #user_spoken_languages,
    #user_international_activity_countries,
    #user_business_sectors,
    #user_investment_levels
  ').select2()

  setupNetworkSearchSelect2()

  $(window).resize ->
    setupNetworkSearchSelect2()