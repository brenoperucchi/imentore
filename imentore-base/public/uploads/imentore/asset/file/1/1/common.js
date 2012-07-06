
$(document).ready(function() {
  $('#button-cart').bind('click', function() {

    $.ajax({
      url: '/cart',
      type: 'post',
      data: $('.product-info input[type=\'text\'], .product-info input[type=\'hidden\'], .product-info input[type=\'radio\']:checked, .product-info input[type=\'checkbox\']:checked, .product-info select, .product-info textarea'),
      dataType: 'json',
      success: function(json) {
        $('.success, .warning, .attention, information, .error').remove();
        var a = json
        if (json['error']) {
          if (json['error']['warning']) {
            $('#notification').html('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src=/uploads/imentore/asset/file/1/1/close.png  alt="" class="close" /></div>');

            $('.warning').fadeIn('slow');
          }

          for (i in json['error']) {
            $('#option-' + i).after('<span class="error">' + json['error'][i] + '</span>');
          }
        }

        if (json['message']['success']) {
          $('#notification').html('<div class="attention" style="display: none;">' + json['message']['success'] + '<img src=/uploads/imentore/asset/file/1/1/close.png alt="" class="close" /></div>');

          $('.attention').fadeIn('slow');

          $('#cart_total').html(json['cart_total']);
          $('.content table.total').find('tbody').html("");
          $('.content table.total').find('tbody').append("<tr> <td class='cart_total_td' align='left'><b>Sub-Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr> <tr> <td class='cart_total_td' align='left'><b>VAT 17.5%:</b></td> <td align='right'>$87.50</td> </tr> <tr> <td class='cart_total_td' align='left'><b>Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr>");


          var image = $('#image').offset();
          var cart  = $('#cart').offset();

          $('#image').before('<img src="' + $('#image').attr('src') + '" id="temp" style="position: absolute; top: ' + image.top + 'px; left: ' + image.left + 'px;" />');

          params = {
            top : cart.top + 'px',
            left : cart.left + 'px',
            opacity : 0.0,
            width : $('#cart').width(),
            height : $('#cart').height()
          };

          $('#temp').animate(params, 'slow', false, function () {
            $('#temp').remove();
          });
        }
      }
    });
  });
});


$(document).ready(function() {
  /* Search */
  $('.button-search').bind('click', function() {
    url = 'index.php?route=product/search';

    var filter_name = $('input[name=\'filter_name\']').attr('value')

    if (filter_name) {
      url += '&filter_name=' + encodeURIComponent(filter_name);
    }

    location = url;
  });

  $('input[name=\'filter_name\']').keydown(function(e) {
    if (e.keyCode == 13) {
      url = 'index.php?route=product/search';

      var filter_name = $('input[name=\'filter_name\']').attr('value')

      if (filter_name) {
        url += '&filter_name=' + encodeURIComponent(filter_name);
      }

      location = url;
    }
  });

  $("#cart").hover(
  function () {
    $('#cart .content').addClass('active');
    $.ajax({
      url: '/cart',
      dataType: 'json',
      success: function(json) {
        if (json['success']['empty'] == false) {
          $('#cart table.table').html("");
          $('#cart div.cart_spacer').show()
          $('#cart table.table').show()
          $('#cart table.total').show()
          $('#cart div.checkout').show()
          $('#cart div#message').hide()

          for(i in json['success']['items']){
            $('#cart .table').append("<tr> <td class='image'> <a href=' " + json['success']['items'][i]['url'] + " '><img src='" + json['success']['items'][i]['thumbnail_url'] + "' alt='" + json['success']['items'][i]['name'] + "' title='" + json['success']['items'][i]['name'] + "'></a> </td><td class='quantity'>" + json['success']['items'][i]['quantity'] + " x </td><td class='name'><a href='" + json['success']['items'][i]['url'] + "'>" + json['success']['items'][i]['name'] + "</a> <div> </div> </td> <td class='total'>" + json['success']['items'][i]['value'] +    "</td> <td class='remove'> <a id='remove' variant_id='"+json['success']['items'][i]['variant_id']+"' quantity='"+json['success']['items'][i]['quantity']+"'></a></td> </tr>")
          };
          $('#cart table.total').html("").append("<tr> <td class='cart_total_td' align='left'><b>Sub-Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr> <tr> <td class='cart_total_td' align='left'><b>VAT 17.5%:</b></td> <td align='right'>$87.50</td> </tr> <tr> <td class='cart_total_td' align='left'><b>Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr>");
        }else{
          $('#cart div.cart_spacer').hide()
          $('#cart table.table').hide()
          $('#cart table.total').hide()
          $('#cart div.checkout').hide()
          $('#cart div#message').show()
          $('#cart div#message').html("").append("Your shopping cart is empty!")
        }
      }
    });
  },
  function () {
  $('#cart .content').removeClass('active');
  }
);


  /* Mega Menu */
  $('#menu ul > li > a + div').each(function(index, element) {
    // IE6 & IE7 Fixes
    if ($.browser.msie && ($.browser.version == 7 || $.browser.version == 8)) {
      var category = $(element).find('a');
      var columns = $(element).find('ul').length;

      $(element).css('width', (columns * 160) + 'px');
      $(element).find('ul').css('float', 'left');
    }

    var menu = $('#menu').offset();
    var dropdown = $(this).parent().offset();

    i = (dropdown.left + $(this).outerWidth()) - (menu.left + $('#menu').outerWidth());

    if (i > 0) {
      $(this).css('margin-left', '-' + (i + 5) + 'px');
    }
  });

  // IE6 & IE7 Fixes
  if ($.browser.msie) {
    if ($.browser.version <= 6) {
      $('#column-left + #column-right + #content, #column-left + #content').css('margin-left', '240px');

      $('#column-right + #content').css('margin-right', '240px');

      $('.box-category ul li a.active + ul').css('display', 'block');
    }

    if ($.browser.version <= 5) {
      $('#menu > ul > li').bind('mouseover', function() {
        $(this).addClass('active');
      });

      $('#menu > ul > li').bind('mouseout', function() {
        $(this).removeClass('active');
      });
    }
  }
});

$('.success img, .warning img, .attention img, .information img').live('click', function() {
  $(this).parent().fadeOut('slow', function() {
    $(this).remove();
  });
});

function addToCart(product_id) {
  var url = "#{asset_url('close.png')}"
  $.ajax({
    url: '/cart',
    type: 'post',
    data: 'product_id=' + product_id,
    dataType: 'json',
    success: function(json) {
      $('.success, .warning, .attention, .information, .error').remove();

      if (json['redirect']) {
        location = json['redirect'];
      }

      if (json['error']) {
        if (json['message']['warning']) {
          $('#notification').html("<div class='warning' style='display: none;'>" + json['message']['warning'] + "<img src="+ url + " alt='' class='close'/></div>");
        }
      }

      if (json['message']['success']) {
        $('#notification').html('<div class="attention" style="display: none;">' + json['message']['success'] + '<img src="close.png" alt="" class="close" /></div>');

        $('.attention').fadeIn('slow');
        $('#cart_total').html(json['cart_total']);

        $('html, body').animate({ scrollTop: 0 }, 'slow');
      }
    }
  });
}
$('a#remove').live('click',function(){
    var self = $(this);
    $.ajax({
      url: '/cart',
      type: 'delete',
      data: {variant_id:$(this).attr("variant_id"), quantity:$(this).attr("quantity"), number_id:$(this).attr("number_id")} ,
      dataType: 'json',
      success: function(json) {
        $('.success, .warning, .attention, .information').remove();
        // if (json['output']) {
        self.parents('tr').remove();
        var html = $('#cart .table').html();
        if (json['success']['empty'] == false) {
          $('#cart div.cart_spacer').show()
          $('#cart table.table').show()
          $('#cart table.total').show()
          $('#cart div.checkout').show()
          $('#cart div#message').hide()

          $('#cart .table').html("").append(html);
          $('#cart_total').html(json['cart_total']);
          $('#cart table.total').html("").append("<tr> <td class='cart_total_td' align='left'><b>Sub-Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr> <tr> <td class='cart_total_td' align='left'><b>VAT 17.5%:</b></td> <td align='right'>$87.50</td> </tr> <tr> <td class='cart_total_td' align='left'><b>Total:</b></td> <td align='right'>"+ json['total']+"</td> </tr>");
        }else{
          $('#cart_total').html(json['cart_total']);
          $('#cart div.cart_spacer').hide()
          $('#cart table.table').hide()
          $('#cart table.total').hide()
          $('#cart div.checkout').hide()
          $('#cart div#message').show()
          $('#cart div#message').html("").append("Your shopping cart is empty!")
        }

          // $('#cart_total').html(json['total']);
          // $('#cart .content').html(json['output']);
        // }
      }
    });
})

function removeVoucher(key) {
  $.ajax({
    url: 'index.php?route=checkout/cart/update',
    type: 'post',
    data: 'voucher=' + key,
    dataType: 'json',
    success: function(json) {
      $('.success, .warning, .attention, .information').remove();

      if (json['output']) {
        $('#cart_total').html(json['cart_total']);

        $('#cart .content').html(json['output']);
      }
    }
  });
}

function addToWishList(product_id) {
  $.ajax({
    url: 'index.php?route=account/wishlist/update',
    type: 'post',
    data: 'product_id=' + product_id,
    dataType: 'json',
    success: function(json) {
      $('.success, .warning, .attention, .information').remove();

      if (json['success']['items']) {
        $('#notification').html('<div class="attention" style="display: none;">' + json['success']['items'] + '<img src="close.png" alt="" class="close" /></div>');

        $('.attention').fadeIn('slow');

        $('#wishlist_total').html(json['total']);

        $('html, body').animate({ scrollTop: 0 }, 'slow');
      }
    }
  });
}

function addToCompare(product_id) {
  $.ajax({
    url: 'index.php?route=product/compare/update',
    type: 'post',
    data: 'product_id=' + product_id,
    dataType: 'json',
    success: function(json) {
      $('.success, .warning, .attention, .information').remove();

      if (json['success']['items']) {
        $('#notification').html('<div class="attention" style="display: none;">' + json['success']['items'] + '<img src="close.png" alt="" class="close" /></div>');

        $('.attention').fadeIn('slow');

        $('#compare_total').html(json['total']);

        $('html, body').animate({ scrollTop: 0 }, 'slow');
      }
    }
  });
}
