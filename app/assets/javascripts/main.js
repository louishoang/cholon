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
    buttons: "bold,italic,underline,strike,|,img,video,link,|,bullist,numlist,|,fontcolor,fontsize,fontfamily,|,justifyleft,justifycenter,justifyright,|,quote,code,table,removeFormat"
  };

  $(".text-editor").wysibb(wbbOpt);



})