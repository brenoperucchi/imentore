 $(document).ready(function() {
	 
	 if ($.browser.msie && ($.browser.version == 8 || $.browser.version == 7 || $.browser.version == 6)) {
	 }
	 else {
	 
	$(".box-product > div").hover(
  function () {
 
   $(this).siblings().stop().animate({
  opacity: .6

}, 500)
  },
  function () {
  
      $(this).siblings().stop().animate({
  opacity: 1

}, 500)
   
  }
);  
  	$(".product-grid > div").hover(
  function () {
 
   $(this).siblings().stop().animate({
  opacity: .6
}, 500)
  },
  function () {
  
      $(this).siblings().stop().animate({
  opacity: 1
}, 500)
   
  }
);
  	
	 }
   
  $(".box-category > ul > li > a").hover(function () {
$(this).stop().animate({ left: "5" }, "fast"); },
function () {
$(this).stop().animate({ left: "0" }, "medium");
}); 
  

    $("#menu > ul > li").hover(function () {
$(this).stop().children('div').slideDown('fast', function() {
    // Animation complete.
  });

; },

function () {
$(this).stop().children('div').slideUp('medium', function() {
    // Animation complete.
  });
}); 

	// Animation for the languages and currency dropdown
    $('.switcher').hover(function() {
    $(this).find('.option').stop(true, true).slideDown(300);
    },function() {
    $(this).find('.option').stop(true, true).slideUp(150);
    }); 
  
 });



