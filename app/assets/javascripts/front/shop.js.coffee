$ ->
  $('.btn-check-coupon').click ->
    $(this).parents('.panel-footer')
    .find('.input-group-addon')
      .removeClass('glyphicon glyphicon-ok glyphicon-remove');
    .end().find('.fa-spinner')
      .show()
      .css('visibility', 'visible');
