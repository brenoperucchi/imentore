(function() {

  $(function() {
    $("a[rel='colorbox']").colorbox();
    $('#first-tour-thumb').twipsy({
      offset: 2,
      placement: 'below',
      trigger: 'manual'
    }).twipsy('show');
    $('#first-tour-thumb').mouseover(function() {
      return $('#first-tour-thumb').twipsy('hide');
    });
    $('#first-tour-thumb').mouseout(function() {
      return $('#first-tour-thumb').twipsy('show');
    });
    $('.tour-thumb').mouseover(function() {
      return jQuery(this).stop().fadeTo(200, 0.6);
    });
    return $('.tour-thumb').mouseout(function() {
      return jQuery(this).stop().fadeTo(400, 1.0);
    });
  });

}).call(this);
