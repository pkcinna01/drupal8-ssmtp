(function($) {

var navbar = $('.navigation');
var origPadLeft = navbar.css('padding-left');
var origPadRight = navbar.css('padding-right');

if ( navbar ){
  var navbarOffset = navbar.offset().top;

  function updateNavbar(isResize) {
    var navbar = $('.navigation');
    var isSticky = navbar.hasClass('navbar-sticky-top');
    if ( $(window).width() < 767 && !isSticky) {
      return;
    }
    if ($(window).scrollTop() >= navbarOffset){
      var spacer = $('#navigation-spacer');
      var navRect = navbar[0].getBoundingClientRect();
      if (!isSticky){
        spacer.css('height',navbar.css('height'));
        navbar.addClass('navbar-sticky-top');
        navbar.css('left',navRect.left);
        navbar.css('width',navRect.right - navRect.left);
        navbar.animate( { 'left': 0, 'width': '100%', 'padding-left': navRect.left, 'padding-right': navRect.left }, 400);
      } else if (isResize){
        var spacerRect = spacer[0].getBoundingClientRect();
        navbar.css('padding-left',spacerRect.left);
        navbar.css('padding-right',spacerRect.left);
      }
    } else if ( isSticky ) {
      var spacer = $('#navigation-spacer');
      spacer.css('height','0');
      //var pad = navbar.css('padding-left');
      //navbar.animate({ 'padding-left': 0, 'padding-right': 0, 'margin-left': pad, 'margin-right': pad},400);
      navbar.removeClass('navbar-sticky-top');
      navbar.css('padding-left',origPadLeft);
      navbar.css('padding-right',origPadRight);
      navbar.css('margin-left',0);
      navbar.css('margin-right',0);
    } 
  }

  $(window).scroll(function(){ updateNavbar(false); });
  $(window).resize(function(){ updateNavbar(true); });
  updateNavbar();
}
})(jQuery);