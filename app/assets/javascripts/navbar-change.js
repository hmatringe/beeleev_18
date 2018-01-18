$(window).scroll(function() {    

    var scroll = $(window).scrollTop();

    if (scroll > 505 && scroll < 2005 || scroll > 2677) {
        $('.lemenu18_transparent').addClass('scrolled_transparent')
        $('#white-logo').addClass('logo-hidden')
        $('#blue-logo').removeClass('logo-hidden')

    } else {
        $('.lemenu18_transparent').removeClass('scrolled_transparent')
        $('#white-logo').removeClass('logo-hidden')
        $('#blue-logo').addClass('logo-hidden')
    }
});
