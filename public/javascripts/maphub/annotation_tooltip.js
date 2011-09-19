/* Creates a tooltip for each annotation */

MapHub.AnnotationTooltip = function(text) {
  this.div = document.createElement("div");
  this.div.innerHTML = text;
  this.div.setAttribute("class", "pelagios-tooltip");
  this.div.style.position = "absolute";
  this.hide();
  document.body.appendChild(this.div);
}

MapHub.AnnotationTooltip.OFFSET_X = 15;
MapHub.AnnotationTooltip.OFFSET_Y = 5;

MapHub.AnnotationTooltip.prototype.show = function(x, y) {
  this.div.style.left = x + MapHub.AnnotationTooltip.OFFSET_X;
  this.div.style.top = y + MapHub.AnnotationTooltip.OFFSET_Y;
  this.div.style.visibility = "visible";
}

MapHub.AnnotationTooltip.prototype.hide = function() {
  this.div.style.visibility = "hidden";
}

MapHub.AnnotationTooltip.prototype.remove = function() {
  // TODO
}