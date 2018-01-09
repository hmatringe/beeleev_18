$(document).on 'ready page:load', ->

  $('#home-slideshow').bxSlider(
    'mode': 'fade',
    'controls': false,
    'speed': 1500,
    'auto': true,
    'pause': 8000
  );

  openSignInModal() if shouldOpenSignInModal()

  $('a.smoothscroll').on 'click', (event) ->

    # if we are already on the homepage, do the smoothscroll
    # if we are on another page, let the anchor tag work normally
    if window.location.pathname == "/"
      event.preventDefault()

      # get only the framgent part of the URL in the href attribute
      url = $(@).attr('href')
      fragment = url.substring url.indexOf("#")

      # do the actual scroll
      $(document).scrollTo $(fragment), 800

  setVideoSize();

shouldOpenSignInModal = ->
  window.location.hash == "#sign_in"

openSignInModal = ->
  $('#navbar-signin-btn').click()

setVideoSize = ->
  if $(window).width() <= 768
    $('#video iframe').width('280').height('158');
  else
    $('#video iframe').width('640').height('360');
