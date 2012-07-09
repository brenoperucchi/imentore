jQuery( function($) {

  var site_options = {
    'main_color'      : '#ff8800',
    'secondary_color' : '#40aebd'      
  }

  // Slider options
  $("#product_intro_preview").slides({
    slideSpeed: 800,
    next: 's_button_next',
    prev: 's_button_prev',
    play: 5000,
    generatePagination: false,
    animationStart: function() {
      $("#product_intro_info > div:visible").fadeOut('slow');
    },
    animationComplete: function(current) {
      number = $("#product_intro_preview div.slideItem").index($("#product_intro_preview div.slideItem:visible"));
      $("#product_intro_info > div").eq(number).fadeIn();
    }
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