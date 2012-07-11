// Creates a new tooltip div for that control point
maphub.ControlPointTooltip = function(control_point, user_id) {
  // outer tooltip container
  this.div = $(document.createElement("div"));
  this.div.attr("class", "control-point-tooltip");
  this.div.attr("id", "control-point-tooltip-" + control_point.id);
  
  // body
  this.div_body = $(document.createElement("div"));
  this.div_body.attr("class", "control-point-tooltip-body");
  this.div_body.html(control_point.geonames_label);
  
  this.div_delete = $(document.createElement("div"));
  this.div_delete.attr("class", "control-point-tooltip-body");
  this.div_delete.html("<hr><small><a href='/control_points/" + control_point.id + "' data-confirm='Are you sure?' data-method='delete' rel='nofollow'><i class='icon-trash'></i> Delete</a></small>");
  
  // append everything
  this.div_body.appendTo(this.div);
  if (user_id == control_point.user_id) {
    this.div_delete.appendTo(this.div);
  }
  this.div.prependTo("#tooltip-selected");
  
  this.div.hide();
}

// simply show a control point tooltip if it already exists
maphub.ControlPointTooltip.prototype.show = function(x, y) {
  this.div.css("left", x);
  this.div.css("top", y);
  this.div.show();
}

// hide a control point tooltip if it already exists
maphub.ControlPointTooltip.prototype.hide = function() {
  this.div.hide();
}
