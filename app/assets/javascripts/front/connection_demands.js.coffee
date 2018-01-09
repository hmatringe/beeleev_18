# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('.toggle-pending-connection-demand-modal').on 'click', togglePendingConnectionDemandModal

togglePendingConnectionDemandModal = ->
  $('#pendingConnectionDemandForm').attr 'action', $(this).data().href
  $('#pendingConnectionDemandRequesterName').html $(this).data().requesterName
  $('#pendingConnectionDemandDescription').html $(this).data().description
  $('#pendingConnectionDemand').modal()
  false
