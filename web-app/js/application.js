var Ajax;
if (Ajax && (Ajax != null)) {
	Ajax.Responders.register({
	  onCreate: function() {
        if($('spinner') && Ajax.activeRequestCount>0)
          Effect.Appear('spinner',{duration:0.5,queue:'end'});
	  },
	  onComplete: function() {
        if($('spinner') && Ajax.activeRequestCount==0)
          Effect.Fade('spinner',{duration:0.5,queue:'end'});
	  }
	});
}

jQuery.fn.limitMaxlength = function(options){

  var settings = jQuery.extend({
    attribute: "maxlength",
    onLimit: function(){},
    onEdit: function(){}
  }, options);
  
  // Event handler to limit the textarea
  var onEdit = function(){
    var textarea = jQuery(this);
    var maxlength = parseInt(textarea.attr(settings.attribute));

    if(textarea.val().length > maxlength){
      textarea.val(textarea.val().substr(0, maxlength));
      
      // Call the onlimit handler within the scope of the textarea
      jQuery.proxy(settings.onLimit, this)();
    }
    
    // Call the onEdit handler within the scope of the textarea
    jQuery.proxy(settings.onEdit, this)(maxlength - textarea.val().length);
  }

  this.each(onEdit);

  return this.keyup(onEdit)
        .keydown(onEdit)
        .focus(onEdit);
}
