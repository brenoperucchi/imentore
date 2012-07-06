$(document).ready(function() {

    function render_add_to_cart(variant_id, product_id, quantity) {

      $.ajax({
        type:'POST',
        cache: false,
        data: {'[item][variant_id]':variant_id, '[item][product_id]':product_id, '[item][quantity]':quantity},
        dataType:'json',
        url:'/cart',
        beforeSend: function() {
          
        },
        complete: function(json,txt) {
          
        },
        success: function(json) { 
          $('div.notification.success').find('#notification_text').text(json.message.success)
          $('div#notification').fadeIn('slow');
          $('div#notification').delay(3000).fadeOut('slow');
          $('#cart_menu').find('span.s_grand_total').text(json.total_amount)          
        }
      })
    }
      
    // product index
    $('.s_button_add_to_cart').bind('click',function(){
       if ($(this).attr('id') == "no_cart"){
       }else{
        var quantity = $(this).first().children('#quantity').val()
        var product_id = $(this).first().children('#product_id').val()
        var variant_id = $(this).first().children('#variant_id').val()
        render_add_to_cart(variant_id, product_id, quantity)
      }
    })
    
    // product show
    $('a#add_to_cart').bind('click',function(){
      if ($(this).attr('id') == "no_cart"){
      }else{
        var quantity = $('input#quantity').val()
        var variant_id = $('select#options').find('option:selected').val()      
        var product_id = $('input#product_id:hidden').val()
        render_add_to_cart(variant_id, product_id, quantity)
      }
    })

});

