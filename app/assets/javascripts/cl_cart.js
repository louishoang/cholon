(function ( $ ) {
  scrollToBasket =  function(){
    $('html, body').animate({
        scrollTop: $($basket).offset().top - 50
    }, 1000);
  }
  
  $.fn.updateBasket = function(){
    $.ajax({
      url: $(this).data("refresh-url"),
      dataType: "json",
      success: function(resp){
        $basketCount.text(resp.count);
        scrollToBasket();
      }
    })
  }

  $.fn.clCart = function(options){
    userID = Cookies.get("user_id");
    orderID = Cookies.get("order_id");

    $(this).find(".atc-btn").each(function(index, elm){
      var $addBtn = $(elm);
      
      $addBtn.on("click", function(){
        quantity = getQuantity($addBtn);
        variantID = $addBtn.data("product-variant-id");
        sellerID = $addBtn.data("seller-id");
        addItem(quantity, variantID);
      });
    });

    function addItem(quantity, variantID){
      $.ajax({
        url: "/order_items",
        method: "POST",
        data: {"order_item": {"quantity": quantity, "product_variant_id": variantID}},
        success: function(resp){
          $basket.updateBasket();
        },
        error: function(e, xhr, status, error){
          debugger;
          if(resp && resp.message){
            toastr.error(resp.responseJSON.message, "Error");
          }
        }
      });
    } 

    function getQuantity($elm){
      $parentDiv = $($elm.parents(".add-to-cart"));
      if($parentDiv.length > 0){
        quantity = parseInt($parentDiv.find(".atc-quantity").val());
      }else{
        quantity = 1;
      }
      return quantity;
    }
    
  };
}( jQuery ));