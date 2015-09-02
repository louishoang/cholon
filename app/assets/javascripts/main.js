$(function() {
  // Get paras attributes
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

  var renderUI = function(){
    $(".text-editor").wysibb(wbbOpt);

    //select2
    $(".select2class").select2({});

    var dropZoneExist = $(document).find(".dropzone").size() > 0;

    if (dropZoneExist){
      $myDropZone = $(document).find(".dropzone");
      $replaceValue = $($myDropZone.data("replace-value"));;

      Dropzone.autoDiscover = false;
      var dropzone = new Dropzone (".dropzone", {
        maxFilesize: 10, // Set the maximum file size to 256 MB
        paramName: "product_photo[photo]", // Rails expects the file upload to be something like model[field_name]
        addRemoveLinks: false, // Don't show remove links on dropzone itself. 
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
    }

    // popup modal ajax
    $('.ajax-popup-link').magnificPopup({
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
        ajaxContentAdded: function() {
          renderUI();
        }
      }
    });

    //jquery gallery jssor
    jssorExist = $(document).find("#jssor").size() > 0;
    if (jssorExist){
      var options = {
                $DragOrientation: 3,                                //[Optional] Orientation to drag slide, 0 no drag, 1 horizental, 2 vertical, 3 either, default value is 1 (Note that the $DragOrientation should be the same as $PlayOrientation when $DisplayPieces is greater than 1, or parking position is not 0)
                $SlideDuration: 500,                                //[Optional] Specifies default duration (swipe) for slide in milliseconds, default value is 500

                $ArrowNavigatorOptions: {                       //[Optional] Options to specify and enable arrow navigator or not
                    $Class: $JssorArrowNavigator$,              //[Requried] Class to create arrow navigator instance
                    $ChanceToShow: 2,                               //[Required] 0 Never, 1 Mouse Over, 2 Always
                    $AutoCenter: 2,                                 //[Optional] Auto center arrows in parent container, 0 No, 1 Horizontal, 2 Vertical, 3 Both, default value is 0
                    $Steps: 1                                       //[Optional] Steps to go for each navigation request, default value is 1
                },
                $ThumbnailNavigatorOptions: {                       //[Optional] Options to specify and enable thumbnail navigator or not
                    $Class: $JssorThumbnailNavigator$,              //[Required] Class to create thumbnail navigator instance
                    $ChanceToShow: 2,                               //[Required] 0 Never, 1 Mouse Over, 2 Always

                    $ActionMode: 1,                                 //[Optional] 0 None, 1 act by click, 2 act by mouse hover, 3 both, default value is 1
                    $SpacingX: 8,                                   //[Optional] Horizontal space between each thumbnail in pixel, default value is 0
                    $DisplayPieces: 10,                             //[Optional] Number of pieces to display, default value is 1
                    $ParkingPosition: 360                           //[Optional] The offset position to park thumbnail
                }
            };
      var jssor_slider1 = new $JssorSlider$('jssor', options);
    }
  };

  // calling render jquery 
  renderUI();

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
      pos["top"] += 25;
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

  $(".photo_preview_list").on("change", function(e){
    $appendTo = $(e.target).closest("td");
    ids = $(e.target).val().replace("[", "").replace("]", "");

    $.ajax({
      type: "GET",
      url: "/product_photos/gallery",
      data: {ids: ids},
      success: function(resp){
        debugger;
      }
    });
  });
});