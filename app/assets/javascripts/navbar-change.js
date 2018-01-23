$(window).scroll(function() {    
    var navbarSwitch = document.getElementById('navbar-switch');
    // console.log(navbarSwitch)

    function checkVisible(elm) {
      var rect = elm.getBoundingClientRect();
      var viewHeight = Math.max(document.documentElement.clientHeight, window.innerHeight);
      return !(rect.bottom < 0 || rect.top - viewHeight >= 0);
    }
    // console.log(!checkVisible(navbarSwitch));
    var scroll = $(window).scrollTop();

    if (scroll > 350 && !checkVisible(navbarSwitch)) {
        $('.lemenu18_transparent').addClass('scrolled_transparent')
        $('#white-logo').addClass('logo-hidden')
        $('#blue-logo').removeClass('logo-hidden')

    } else {
        $('.lemenu18_transparent').removeClass('scrolled_transparent')
        $('#white-logo').removeClass('logo-hidden')
        $('#blue-logo').addClass('logo-hidden')
    }
});

