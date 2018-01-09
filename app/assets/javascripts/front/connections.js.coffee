$(document).on 'ready page:load', ->

  # bind the 'click' event on .connection-reject-link elements inside a .modal-
  # content to :
  #
  # - disable the .connection-accept-link
  # - display the textarea#connection_proposition_reject_description element
  # - invalidate the form submition if
  #   textarea#connection_proposition_reject_description is empty
  $('.modal-content').on 'click', '.connection-reject-link', ->

    # disable the .connection-accept-link
    $(@).parents('form')
      .find('.connection-accept-link')
      .attr('disabled', 'disabled')

    textarea = $(@).parents('form')
                .find('textarea.connection-reject-description')

    rejectReasonIsPresent = !!textarea.val()

    # if the textarea is not visible, empty its possible, show it and halt the
    # form submition
    #
    # if the textarea is visible and empty, show an alert to force the user to
    # provide the reject reason and halt the form submition
    #
    # Else, let the form submition proceed
    if !textarea.is(":visible")
      textarea.val(null)
      textarea.show()
      return false
    else if !rejectReasonIsPresent
      alert "Please describe why you reject this connection"
      return false
    else
      # let the form submition proceed
