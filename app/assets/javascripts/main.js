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

  $(".text-editor").wysibb(wbbOpt);

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

  //select
  $(".select2class").select2({});

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
});