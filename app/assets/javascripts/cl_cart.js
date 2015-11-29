(function ( $ ) {
  $.fn.updateBasket = function(){
    $.ajax({
      url: $(this).data("refresh-url"),
      dataType: "json",
      success: function(resp){
        $basketCount.text(resp.count);
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
        productID = $addBtn.data("product-id");
        addItem(quantity, productID);
      });
    });

    function addItem(quantity, productID){
      $.ajax({
        url: "/order_items",
        method: "POST",
        data: {"order_item": {"quantity": quantity, "product_id": productID}},
        success: function(resp){
          debugger;
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