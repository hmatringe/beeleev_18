$(document).ready(function() {
  $(window).keydown(function(event){
    if($('#connection_request_description').length && event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
});