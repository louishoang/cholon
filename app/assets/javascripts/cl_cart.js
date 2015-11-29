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
    userID = options["user_id"];
    orderID = options["oder_id"];
    cartInit = sessionStorage.getItem("cartInit"); // check if cart if load when first login

    $(this).find(".atc-btn").each(function(index, elm){
      var $addBtn = $(elm);
      
      $addBtn.on("click", function(){
        //Find the quantity of item
        quantity = getQuantity($addBtn);
        addItem(quantity);
      });
    });

    function addItem(quantity){
      alert("added" + quantity)
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