// Creates a new tooltip div for that annotation
maphub.AnnotationTooltip = function(annotation, user_id) {
  // outer tooltip container
  this.div = $(document.createElement("div"));
  this.div.attr("class", "annotation-tooltip");
  this.div.attr("id", "annotation-tooltip-" + annotation.id);
  
  // body
  this.div_body = $(document.createElement("div"));
  this.div_body.attr("class", "annotation-tooltip-body");
  this.div_body.html(annotation.body);
  
  // user
  this.div_user = $(document.createElement("div"));
  this.div_user.attr("class", "annotation-tooltip-user single-user-container");
  // copy from existing table row instead:
  this.div_user.html($("#annotation-" + annotation.id + " .single-user-container").html());
  
  // append everything
  this.div_body.appendTo(this.div);
  this.div_user.appendTo(this.div);
  this.div.prependTo("#tooltip-selected");
  
  this.div.hide();
}

// simply show an annotation tooltip if it already exists
maphub.AnnotationTooltip.prototype.show = function(x, y) {
  this.div.css("left", x);
  this.div.css("top", y);
  this.div.show();
}

// hide an annotation tooltip if it already exists
maphub.AnnotationTooltip.prototype.hide = function() {
  this.div.hide();
}
