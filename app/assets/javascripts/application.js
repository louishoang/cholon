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
$(document).ready(function() {
  $.validate({
    ignore: '[]',
    form: ".register-form",
    modules : 'html5',
    validateOnBlur : true,
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

  $(".register-form").on("select2:select", function(e){
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
});


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
    toastr.success(xhr.responseText);
  }).on("ajax:error", function(e, xhr, status, error){
    toastr.error(xhr.responseText, "Error");
  });
});