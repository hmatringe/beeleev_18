$(window).scroll(function() {    

    var scroll = $(window).scrollTop();

    if (scroll >= 1) {
        $('.lemenu18_transparent').addClass('scrolled_transparent')
        $('#white-logo').addClass('logo-hidden')
        $('#blue-logo').removeClass('logo-hidden')

    } else {
        $('.lemenu18_transparent').removeClass('scrolled_transparent')
        $('#white-logo').removeClass('logo-hidden')
        $('#blue-logo').addClass('logo-hidden')
    }
});
