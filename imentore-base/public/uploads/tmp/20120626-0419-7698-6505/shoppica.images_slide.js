jQuery( function($) {

  var site_options = {
    'main_color'      : '#ff8800',
    'secondary_color' : '#40aebd'      
  }

  // Slider options
  $("#image_intro").slides({
    effect: slideEffect,
    crossfade: true,
    preload: true,
    fadeSpeed: 800,
    slideSpeed: 800,
    next: 's_button_next',
    prev: 's_button_prev',
    play: 5000,
    generatePagination: false
  });

  // Next/Prev buttons hover effect
  $("#intro .s_button_prev, #intro .s_button_next").hover(
    function() {
      $(this).stop().animate({
          backgroundColor: site_options.secondary_color
        },300
      );
    }
    ,
    function() {
      $(this).stop().animate({
          backgroundColor: site_options.main_color
        },300
      );
    }
  );
  
});