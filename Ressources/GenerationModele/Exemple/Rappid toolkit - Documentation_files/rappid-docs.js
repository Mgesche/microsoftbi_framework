$(function() {

    var header = $('.content-container > h2:first-child').text() + '';
    var $menuLink = $('.content-sidebar a:contains(' + header.trim() + ')');

    $('.content-sidebar').animate({
        scrollTop: $menuLink.offset().top - 20
    }, 300);
});
