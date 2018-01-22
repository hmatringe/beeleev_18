
$(window).scroll(function() {    


    var navbar_switch = document.getElementById('navbar-switch');

    window.onscroll = function() {
      checkVisible(navbar_switch) ? console.log('visible') : console.log('hidden');
    };

    function checkVisible(elm) {
      var rect = elm.getBoundingClientRect();
      var viewHeight = Math.max(document.documentElement.clientHeight, window.innerHeight);
      return !(rect.bottom < 0 || rect.top - viewHeight >= 0);
    }

    var scroll = $(window).scrollTop();

    if (scroll > 505 && scroll < 2005 || window.onscroll = function() {checkVisible(navbar_switch)};) {
        $('.lemenu18_transparent').addClass('scrolled_transparent')
        $('#white-logo').addClass('logo-hidden')
        $('#blue-logo').removeClass('logo-hidden')

    } else {
        $('.lemenu18_transparent').removeClass('scrolled_transparent')
        $('#white-logo').removeClass('logo-hidden')
        $('#blue-logo').addClass('logo-hidden')
    }
});