var loadingHtml= '<div class="la-line-spin-fade-rotating la-dark"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>';
var CL = CL || {
  //Show the loading image and disable div from any actions
  showLoading: function(elm){
    $(elm).addClass("loading");
    $(elm).before(loadingHtml);
    $(elm).find("*").each(function(idx, link){
      $(link).attr("disabled", "disabled");
    });
  },
  removeLoading: function(){
    $(document).find(".loading").removeClass("loading");
    $(document).find(".la-line-spin-fade-rotating").remove();
  },
  //send ajax request to get new content
  getContent: function(elm){
    url = $(elm).data("url");
    if(url != undefined){
      $.ajax({
        url: url,
        data: {refresh: true}
      })
    }
  },
  refresh: function(elm){
    this.showLoading(elm);
    this.getContent(elm);
  }
};