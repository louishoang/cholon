// Get params attributes
function getUrlParameter(sParam){
  var sPageURL = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');
  for (var i = 0; i < sURLVariables.length; i++)
  {
    var sParameterName = sURLVariables[i].split('=');
    if (sParameterName[0] == sParam)
    {
      return sParameterName[1];
    }
  }
};

function getUrlParameterHash(){
  var sPageURL = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');

  var myHash = {};

  for (var i = 0; i < sURLVariables.length; i++){
    var sParameterName = sURLVariables[i].split('=');
    myHash[sParameterName[0]] = sParameterName[1];
  }
  return myHash;
};

function union_arrays (x, y) {
  var obj = {};
  for (var i = x.length-1; i >= 0; -- i)
     obj[x[i]] = x[i];
  for (var i = y.length-1; i >= 0; -- i)
     obj[y[i]] = y[i];
  var res = []
  for (var k in obj) {
    if (obj.hasOwnProperty(k) && obj[k] != "")  // <-- optional
      res.push(obj[k]);
  }
  return res;
}

// Find language for text editor
if (getUrlParameter("locale") == "vi_VN"){
  var wbbOptLang = "vi_VN";
}else{
  var wbbOptLang = "en_CA";
}

var renderUI = function(cx){
  //HTML text editor
  tinymce.init({
    selector: ".text-editor",
    menubar: false,
    language: wbbOptLang,
    setup: function(editor) {
      // handle instruction tooltip on the side
      editor.on('focus', function(e) {
        $this = $("#product_description");

        title = $this.data("tooltip-title");
        content = $this.data("tooltip");
        $container = $this.closest(".container");
        $tooltipPanel = $container.find(".tooltip-panel");

        pos = $(".mce-panel").offset();
        $tooltipPanel.find(".panel-title").html(title);
        $tooltipPanel.find(".panel-body").html(content);
        $tooltipPanel.trigger("showAndPosition", pos);

        $("#product_description").trigger("focus");
      });

      editor.on("keyup change", function(e){
        e.preventDefault();
        // copy content to the selector for validation;
        _content = tinyMCE.activeEditor.getContent();
        $(".text-editor").text(tinyMCE.activeEditor.getContent()); 
        tinyMCE.triggerSave(); 
      });

      editor.on('blur', function(e){
          
      });
    },
    plugins: [
      "advlist autolink link image lists charmap hr anchor pagebreak spellchecker",
      "searchreplace visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
      "table contextmenu directionality emoticons template paste textcolor"
    ],
    toolbar: "code styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | media fullpage | forecolor backcolor emoticons | insertfile undo redo" , 
    style_formats: [
      {title: 'Bold text', inline: 'b'},
      {title: 'Red text', inline: 'span', styles: {color: '#ff0000'}},
      {title: 'Red header', block: 'h1', styles: {color: '#ff0000'}},
      {title: 'Example 1', inline: 'span', classes: 'example1'},
      {title: 'Example 2', inline: 'span', classes: 'example2'},
      {title: 'Table styles'},
      {title: 'Table row 1', selector: 'tr', classes: 'tablerow1'}
      ]
   });

  //lazy load
  echo.init({
    offset: 100,
    throttle: 250,
    unload: false,
    callback: function (element, op) {
    }
  });

  echo.render();

  $(".option-autocomplete", cx).autocomplete({
    delay: 500,
    minLength: 2,
    source: "/product_options"
  })

  //select2
  $(".select2class", cx).select2({});

  //jquery equal height
  $(".top", cx).matchHeight({});

  //image upload dropzone
  var dropZoneExist = $(cx).find(".dropzone").size() > 0;

  if (dropZoneExist){
    $myDropZone = $(cx).find(".dropzone");
    $replaceValue = $($myDropZone.data("replace-value"));;

    Dropzone.autoDiscover = false;
    var dropzone = new Dropzone (".dropzone", {
      maxFilesize: 5, // Set the maximum file size to 10 MB
      maxFiles: 5, //maximum number of file can be uploaded
      paramName: "product_photo[photo]", // Rails expects the file upload to be something like model[field_name]
      addRemoveLinks: true, // show remove links on dropzone itself. 
      headers: {
        'X-CSRF-Token': $('meta[name="token"]').attr('content')
      }
    }); 
    dropzone.on("success", function(file) {
      resp = jQuery.parseJSON(file.xhr.response);
      if ($replaceValue.size() > 0){
        $replaceValue.val($replaceValue.val() + ',' + resp.id);
      }
    });
    dropzone.on("queuecomplete", function(elm){
      $spinner = $(".dropzone").parent().find(".spinner");
      if($spinner.length > 0){
        $spinner.removeAttr("onclick");
        $spinner.removeAttr("disabled").removeClass("spinner");
      } 
    });
    dropzone.on("addedfile", function(file) {
      $(".dropzone").parent().find(".btn").trigger("loading");
    });
  }

  // popup modal ajax
  $('.ajax-popup-link', cx).magnificPopup({
    type: 'ajax',
    cursor: 'mfp-ajax-cur',
    closeOnBgClick: false,
    showCloseBtn: true,
    closeBtnInside: true,
    callbacks: {
      elementParse: function(item) {
        // Function will fire for each target element
        // "item.el" is a target DOM element (if present)
        // "item.src" is a source that you may modify
      },
      ajaxContentAdded: function(e) {
        renderUI(".mfp-container");
      }
    }
  });

  $('.gallery', cx ).jGallery({
    "transition":"moveToLeft_moveFromRight",
    "transitionCols":"1",
    "transitionRows":"1",
    "thumbnailsPosition":"bottom",
    "thumbType":"image",
    "width": '365px',
    "height": "205px",
    "mode": 'slider',
    "thumbHeight": 30,
    "thumbWidth": 30,
    "slideshow": false,
    "browserHistory": false
  });

  $( ".product_gallery", cx ).jGallery( {
    "transition":"moveToLeft_moveFromRight",
    "transitionCols":"1",
    "transitionRows":"1",
    "thumbnailsPosition":"bottom",
    "thumbType":"image",
    "backgroundColor":"F8F8F8",
    "textColor":"000000",
    "mode":"standard",
    "height": "527px",
    "slideshow": false,
    "browserHistory": false
  });
};



$(function() {
  // if user click back button , put a mark in the form to update instead of create
  if(Cookies.get("product_name") !== undefined){
    $productNameTextArea = $(".register-form").find("#product_name");
    if($productNameTextArea.length > 0){
      noBlankSpaceString = $productNameTextArea.val().replace(/ /g,'');
      if(noBlankSpaceString === Cookies.get("product_name")){
        $pageIsDirty = $(".register-form").find("#page_is_dirty");
        if($pageIsDirty.length > 0){
          $pageIsDirty.val('1');
        }
      }
    }
  };

  $.formUtils.addValidator({
    name : 'currency',
    validatorFunction : function(value, $el, config, language, $form) {
      var isValidMoney = /^\d{0,9}(\.\d{0,2})?$/.test($el.val());
      return $el.val().length > 0 && isValidMoney;
    },
    errorMessage : 'Wrong currency format. Ex: 20 or 20.95',
    errorMessageKey: 'badCurrencyFormat'
  });

  // Jquery validation
  if($(".jvalidate").length > 0){
    if($('#product_name').length > 0){
      $('#product_name').restrictLength($('#maxlength'));
    }
    $.validate({
      ignore: [],
      form: ".jvalidate",
      modules : 'html5',
      validateOnBlur : false,
      validateHiddenInputs: true,
      onError : function($form) {
        $form.find(".has-error").each(function(index, elm){

          // fix html text editor on validation
          $tinymcePanel = $(elm).find(".mce-tinymce.mce-container.mce-panel");
          if($tinymcePanel.length > 0){
            $tinymcePanel.attr("style", "border: 1px solid red");
            $tinymcePanel.removeClass("has-error");
          }

          // fix select2 on validation
          $select2 = $(elm).find(".select2class.error");
          if($select2.length > 0){
            $(elm).find(".select2-selection--single").attr("style", "border-color: red");
            $(elm).removeClass("has-error");
          }
        });
      },
      onSuccess : function($form) {
      },
      onValidate : function($form) {
      },
      onElementValidate : function(valid, $el, $form, errorMess) {
        console.log('Input ' +$el.attr('name')+ ' is ' + ( valid ? 'VALID':'NOT VALID') );
      }
    });

    //adjust for jquery validation on html text editor 
    $(".text-editor").on("validation", function(evt, valid){
      if(valid){
        $tinymcePanel = $(".mce-tinymce.mce-container.mce-panel");
        $tinymcePanel.attr("style", "border: 1px solid #3c763d");
      }
    });

    //adjust for jquery validation on select2 
    $(".jvalidate").on("select2:select", function(e){
      if($(e.target).hasClass("error")){
        if($(e.target).val() !== undefined){
          $formGroup = $(e.target).parents(".form-group")
          $formGroup.addClass("has-success");
          $formGroup.find(".select2-selection--single").attr("style", "border-color: #3c763d")
          $formGroup.find(".help-block").remove();
          $(e.target).removeClass("error");
        }
      }
    });
  }

  //jquery hover dropdown
  $('.dropdown-toggle').dropdownHover({
    delay: 200,
    hoverDelay: 300
  });

  $basket = $(document).find(".items-cart-inner");
  if($basket.length > 0){
    $basketCount = $basket.find(".basket-item-count .count");
    $basketSubTotal = $basket.find(".total-price .value");
  }

  if($(".top-cart-row").length > 0){
    $(document).clCart({
      user_id: 1,
      order_id: 1
    });
  }

  $(document).on("renderUI", function(e, context){
    renderUI(context);
  });

  // calling render jquery 
  renderUI(document);

  // #form tooltip start
  $(document).on("focus", "textarea[data-tooltip], input[data-tooltip], div[data-tooltip]", function(e){
    e.preventDefault();
    // Find the element that has data-tooltip
    if ($(e.target).data("tooltip") !== undefined){
      $this = $(e.target);
    }else{
      $this = $($(e.target).parents("[data-tooltip]"));
    } 
    
    //============================================== 
    // NOTE: wysig text editor has its own tooltip method that is similar to this,
    // please find in tinymce callback above
    //================================================

    title = $this.data("tooltip-title");
    content = $this.data("tooltip");
    $container = $this.closest(".container");
    $tooltipPanel = $container.find(".tooltip-panel");
   
    pos = $this.offset();
    
    $tooltipPanel.find(".panel-title").html(title);
    $tooltipPanel.find(".panel-body").html(content);
    $tooltipPanel.trigger("showAndPosition", pos);
  });

  $(".tooltip-panel").on("showAndPosition", function(e, position){
    e.preventDefault();
    _top = position.top - 380;
    $(e.target).fadeIn(1000);
    $(e.target).css({
      position: "relative",
      top: _top + "px"
    });  
  });
  // #form tooltip end

  //selec2 multi level for sub category
  $(document).on("change", ".select2class.multilevel", function(e){
    selected = $(e.target).val();
    url = $(e.target).data("url");
    $subCat = $(e.target).parents(".row-fluid").find("#sub_cat_select");
    $subCat.removeClass("hide");
    $subCat.addClass("spinner");
    
    $.ajax({
      type: "GET",
      url: url,
      data: {"category_id": selected},
      success: function(resp){
        $subCat.html(resp);
        $subCat.removeClass("spinner spinner-box");
      }
    });
  });

  $(document).on("click", ".save_photos", function(e){
    $this = $(e.target).hasClass("save_photos") ? $(e.target) : $(e.target).closest(".save_photos");
    $save = $($this.data("save-what"));
    $saveTo = $($this.data("save-to"));

    if ($save.val().length > 0){
      // turn value into array of ids
      saveValue = $save.val().split(",");
      saveValue.shift();
      $saveTo.val("[" + saveValue + "]").trigger('change');;
    }

    //close popup
    var magnificPopup = $.magnificPopup.instance;
    magnificPopup.close();
  });


  $(document).on("change", ".photo_preview_list",function(e){
    $appendTo = $(e.target).closest("td").find(".gallery-ajax");
    ids = $(e.target).val().replace("[", "").replace("]", "");

    $.ajax({
      type: "GET",
      url: "/product_photos/gallery",
      data: {ids: ids},
      success: function(resp){
        $appendTo.html(resp);
        renderUI($appendTo);
      }
    });
  });

  $(document).on("click", ".clone_product_variant_form", function(e){
    //find index of next row by counting number of row in table - 1(header)
    index = $("#table-product-variants tr").length - 1;
    url = $(this).data("url");
    $.ajax({
      type: "GET",
      url: url,
      data: {index: index},
      success: function(resp){
        $("#table-product-variants tbody").append(resp)
        renderUI("#table-product-variants tr:last");
      }
    });
  });

  $(document).on("click", ".remove-row", function(e){
    $table = $(e.target).parents("table");
    if($table.find("tr").length > 2){
      $(e.target).parents("tr").remove();
    }else{
      toastr.error("Couldn't remove the only variant of product", "Error");
    }
  });

  //price range slider
  if ($(".price-slider").length > 0){
    min = parseFloat($(".price-slider").data("min"));
    max = parseFloat($(".price-slider").data("max"));
    minSelected = parseFloat(getUrlParameter("min_price")) || min;
    maxSelected = parseFloat(getUrlParameter("max_price")) || max

    $( ".price-slider" ).slider({
      range: true,
      min: min,
      max: max,
      value: [minSelected , maxSelected],
      tooltip: 'hide',
    }).on("slide", function( event, ui ) {
      $holder = $(this).closest(".price-range-holder");
      $holder.find(".min").text("$" + event.value[0].toFixed(2));
      $holder.find(".max").text("$" + event.value[1].toFixed(2));
   });
  }


  // Filter checkbox
  $(".filter-params").on("click", function(e){
    urlOnChecked = $(this).data("checked-url");
    urlOnUnchecked = $(this).data("unchecked-url");

    // when clicked element is a div
    isSelectedValue = $(this).is("div") && getUrlParameter("rating") === undefined && $(this).data("rateit-value") + "Up";
    // when clicked element is a checkbox
    isChecked = $(this).is(":checked") && $(this).is("input");

    if(isChecked || isSelectedValue){
      window.location.href = urlOnChecked;
    }else{
      window.location.href = urlOnUnchecked;
    }
    $(e.target)
  })

  //Filter checkbox wrapped inside anchor
  $(".checkbox-as-link").on("click", function(e){
    if($(this).is(":checked")){
      window.location.href = $($(this).parents("a")).attr("href");
    }
  });

  $(".btn").on("loading", function(e){
    $(this).addClass("spinner");
    $(this).attr("onclick", "return false;");
    $(this).attr("disabled", "disabled");
  });

  $(document).on("click", ".btn-preview", function(e){
    $url = $(this).data("url");
    $.ajax({
      type: "GET",
      url: $url,
      success: function(resp){
        if (resp.location.length > 0){
          $(location).attr('href', resp.location);
        }
      },
      error: function(resp){
        toastr.error(resp.responseJSON.message, "Error");
      }
    });
  });

  $(document).on("click", ".btn-publishable", function(e){
    $url = $(this).data("url");
    $.ajax({
      type: "GET",
      url: $url,
      success: function(resp){
        if (resp.location.length > 0){
          $(location).attr('href', resp.location);
          toastr.success(resp.message);
        }
      },
      error: function(resp){
        toastr.error(resp.responseJSON.message, "Error");
      }
    });
  });

  $(document).on("change", ".pp-select", function(e){
    $(location).attr('href', $(".pp-select option:selected").data("url"));
  });

  $(document).on("change", ".shipping-selection", function(e){
    $container = $(this).parents(".form-container");
    $actualPrice = $container.find(".actual_price_shipping");
    $fixedprice = $container.find(".fixed_price_shipping");
    selected = $(this).val();

    if(selected == "actual_cost_shipping"){
      $fixedprice.disableAndHide();
      $actualPrice.enableAndShow();
    }else if(selected == "fixed_cost_shipping"){
      $fixedprice.enableAndShow();
      $actualPrice.disableAndHide();
    }else if(selected == "free_shipping"){
      $fixedprice.disableAndHide();
      $actualPrice.disableAndHide();
    }
  });

  // prevent hidden element to be submitted with form
  $.fn.disableAndHide = function(){
    return this.each(function(){
      $(this).addClass("hide");
      $(this).find("input, select, textarea").each(function(i, elm){
        $(elm).attr("disabled", "disabled");
      });
    }); 
  }

  $.fn.enableAndShow = function(){
    return this.each(function(){
      $(this).removeClass("hide");
      $(this).find("input, select, textarea").each(function(i, elm){
        $(elm).removeAttr("disabled");
      });
    });
  }


  if($(".ajax-content").length > 0){
    $(".ajax-content").each(function(index, elm){
      $elm = $(elm);
      url = $elm.data('url');
      $.ajax({
        url: url,
        success: function(){
          setTimeout(function() { renderUI($elm); }, 500); 
        }
      });
    });
  }

  $(document).on("click", ".btn-variants", function(e){
    e.preventDefault();
    variantID = $(this).data("variant-id");
    price = $(this).data("variant-price");

    $(this).addClass("active");
    $(".btn-variants").not(this).removeClass("active");

    $(".price-box .price").text(price);
    $(".atc-btn").attr("data-product-variant-id", variantID);
  });

  $(document).on("click", ".btn-price-filter", function(e){
    e.preventDefault();
    url = $(this).data("url");
    $rangeDiv = $(this).closest(".sidebar-widget-body").find(".price-range-holder");
    priceRange = $rangeDiv.find(".price-slider").data("value").split(",");
    minPrice = priceRange[0];
    maxPrice = priceRange[1];

    current_query = getUrlParameterHash();

    if(current_query[Object.keys(current_query)[0]] !== undefined){
      query = $.extend(current_query, {min_price: minPrice, max_price: maxPrice});
    }else{
      query = {min_price: minPrice, max_price: maxPrice}
    }
    
    window.location.href = window.location.pathname + "?" + $.param(query);
  });

  //add new row to form dynamicaly, ONLY HANDLE INPUT NOW
  $(document).on("click", ".add-row-form", function(e){
    e.preventDefault();
    $wrapper = $(this).parents(".clone-wrapper");
    nextIndex = $wrapper.find(".clone-elm").not(".toclone").length;
    $toClone = $wrapper.find(".toclone");
    data = $toClone.clone();
    data.find("input").each(function(index, elm){
      newNameWithIndex = $(elm).attr("name").replace(/\d/, nextIndex);
      $(elm).attr("name", newNameWithIndex);
      renderUI(data);
    });
    $wrapper.find(".clone-elm").last().after(data.removeClass("hide toclone"));
  });

  $(document).on("click", "a[data-remove]", function(e){
    e.preventDefault();
    $wrapper = $(this).parents(".clone-wrapper");
    $allToClone = $wrapper.find(".clone-elm").not(".toclone");
    $this = $(this);
    
    if($allToClone.length > 1){
      $this.queue(function(next){
        $this.parents($this.data("remove")).remove();
        next();    
      }).queue(function(next){
        $allToClone = $wrapper.find(".clone-elm").not(".toclone");

        $allToClone.each(function(index, fg){
          currentIndex = index;
          $(fg).find("input, textarea, select").each(function(index, elm){
            newNameWithIndex = $(elm).attr("name").replace(/\d/, currentIndex);
            $(elm).attr("name", newNameWithIndex);
          });
        });
        next();
      });    
    }else{
      toastr.error("This element is required", "Error");
    } 
  });
    
});

//Adjust footer to bottom of page
$(document).ready(function() {
  var docHeight = $(window).height();
  var footerHeight = $('#footer').height();
  var footerTop = $('#footer').position().top + footerHeight;
  if (footerTop < docHeight) {
   $('#footer').css('margin-top', 50 + (docHeight - footerTop) + 'px');
  }
});

$(document).on("change", ".product-option-value-select", function(e){
  optionValueIds = $.map($(".product-option-value-select"), function(a){
    if($(a).val() != ""){
      return $(a).val();
    }
  });
  btnName = ".btn-variants[data-option-value='" + optionValueIds.join(",") + "']";

  $selectedOption = $(btnName);
  if($selectedOption.length > 0){
    $selectedOption.trigger("click");
  }
});

$(document).on("change", ".checkout-quantity", function(e){
  // orderId = ($this).data("order-item-id");
  $(this).parents(".checkout-item").find(".checkout-update").removeClass("hide");

});

$(document).on("click", ".checkout-remove", function(e){
  $(e.target).preventDefault;
  url = $(this).data("url");
  $.ajax({
    url: url,
    method: "POST",
    data: {"_method":"delete"},
  });
})

