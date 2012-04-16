/* Creates a tooltip for each annotation */

MapHub.AnnotationTooltip = function(annotation) {
  this.div = document.createElement("div");
  this.div.setAttribute("class", "annotationTooltip shadow");
  
  this.div_title = document.createElement("h3");
  this.div_title.setAttribute("class", "annotationTitle");
  this.div_title.innerHTML = annotation.title;
  this.div.appendChild(this.div_title);
  
  this.div_body = document.createElement("div");
  this.div_body.setAttribute("class", "annotationBody");
  this.div_body.innerHTML = annotation.body;
  this.div.appendChild(this.div_body); 
  
  this.hide();
  document.getElementById("annotationOverlays").appendChild(this.div);
}

MapHub.AnnotationTooltip.OFFSET_X = 0;
MapHub.AnnotationTooltip.OFFSET_Y = 0;

MapHub.AnnotationTooltip.prototype.show = function(x, y) {
  this.div.style.left = x + MapHub.AnnotationTooltip.OFFSET_X + "px";
  this.div.style.top = y + MapHub.AnnotationTooltip.OFFSET_Y + "px";
  this.div.style.visibility = "visible";
}

MapHub.AnnotationTooltip.prototype.hide = function() {
  this.div.style.visibility = "hidden";
}

MapHub.AnnotationTooltip.prototype.remove = function() {
  // TODO
}