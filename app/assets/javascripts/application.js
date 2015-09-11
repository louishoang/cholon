// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap
//= require dropzone
//= require jquery.form-validator
//= require_tree .
$(document).ready(function(){
  toastr.options = {
    "closeButton": true,
    "debug": false,
    "newestOnTop": false,
    "progressBar": false,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "5000",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };

  $(".form_ajax").on("ajax:success", function(e, data, status, xhr){
    message = data.message;
    if(message !== undefined){
      toastr.success(message);
    }
  }).on("ajax:error", function(e, xhr, status, error){
    message = xhr.message;
    if(message !== undefined){
      toastr.error(message, "Error");
    }  
  }).on("ajax:complete", function(e, xhr, settings){
    resp = $.parseJSON(xhr.responseText);
    location = resp.location;
    if(location){
      $(location).attr('href', location);
    }
  });
});