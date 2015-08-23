$(function() {
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

  if (getUrlParameter("locale") == "vi_VN"){
    var wbbOpt = { lang: "vi"};
  }else{
    var wbbOpt = { lang: "en"};
  }
  $(".text-editor").wysibb(wbbOpt);
})