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
    $('#product_name').restrictLength($('#maxlength'));
    $.validate({
      ignore: '[]',
      form: ".jvalidate",
      modules : 'html5',
      validateOnBlur : false,
      onError : function($form) {
        $form.find(".has-error").each(function(index, elm){
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

  // Find language for text editor
  if (getUrlParameter("locale") == "vi_VN"){
    var wbbOptLang = "vi";
  }else{
    var wbbOptLang = "en";
  }
  var wbbOpt = { 
    lang: wbbOptLang,
    buttons: "bold,italic,underline,strike,|,img,video,link,|,bullist,numlist,|,fontcolor,fontsize,fontfamily,|,justifyleft,justifycenter,justifyright,|,quote,code,table,removeFormat",
    traceTextarea: true
  };

  var renderUI = function(cx){

    //lazy load
    echo.init({
      offset: 100,
      throttle: 250,
      unload: false,
      callback: function (element, op) {
      }
    });

    echo.render();

    $(".text-editor", cx).wysibb(wbbOpt);

    //select2
    $(".select2class", cx).select2({});

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
      "width": '200px',
      "height": "200px",
      "mode": 'slider',
      "browserHistory": true,
      "thumbHeight": 30,
      "thumbWidth": 30,
      "slideshow": false,
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
      "browserHistory": true,
      "slideshow": false,
    });
  };

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
    
    // handle wysibb text editor 
    $toBeAlignWidth = $($this.closest($this.data("tooltip-parent")));
    if($toBeAlignWidth.size() > 0){
      $parent = $toBeAlignWidth;
    }else{
      $parent = $this.find($this.data("tooltip-parent"));;
    }

    title = $this.data("tooltip-title");
    content = $this.data("tooltip");
    $container = $this.closest(".container");
    $tooltipPanel = $container.find(".tooltip-panel");

    // if multiple elements are in one row, use position of parent
    if ($parent.size() > 0){
      pos = $parent.position();
      pos["top"] += 100;
    }else{
      pos = $this.position();
    }
    $tooltipPanel.find(".panel-title").html(title);
    $tooltipPanel.find(".panel-body").html(content);
    $tooltipPanel.trigger("showAndPosition", pos);
  });

  $(".tooltip-panel").on("showAndPosition", function(e, position){
    e.preventDefault();
    $(e.target).fadeIn(1000);
    $(e.target).css({
      position: "relative",
      top: position.top + "px"
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
        $("#table-product-variants").append(resp)
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
    $( ".price-slider" ).slider({
      range: true,
      min: min,
      max: max,
      value: [min, max],
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

  //jquery equal height
  $(".top").matchHeight();

  $(".btn").on("loading", function(e){
    $(this).addClass("spinner");
    $(this).attr("onclick", "return false;");
    $(this).attr("disabled", "disabled");
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
        }else{
          toastr.error(resp.message, "Error");
        } 
      }
    });
  });

  $(document).on("change", ".pp-select", function(e){
    $(location).attr('href', $(".pp-select option:selected").data("url"));
  });
});