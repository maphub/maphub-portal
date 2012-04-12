//= require OpenLayers

MapHub = {}

MapHub.AnnotationView = function(width, height, zoomify_url) {
  
  this.zoomify_width = width;
  this.zoomify_height = height;
  this.zoomify_url = zoomify_url;
  
  /* The zoomify layer */
  this.baseLayer = new OpenLayers.Layer.Zoomify( "Zoomify", this.zoomify_url, 
      new OpenLayers.Size( this.zoomify_width, this.zoomify_height ) );

  /* Display options */
  var options = {
      controls: [], 
      maxExtent: new OpenLayers.Bounds(0, 0, this.zoomify_width, this.zoomify_height),
      maxResolution: Math.pow(2, this.baseLayer.numberOfTiers-1),
      numZoomLevels: this.baseLayer.numberOfTiers,
      units: 'pixels'
  };

  this.map = new OpenLayers.Map("viewer", options);

  this.map.addLayer(this.baseLayer);

  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.map.addControl(new OpenLayers.Control.MouseDefaults());
  this.map.addControl(new OpenLayers.Control.KeyboardDefaults());

  this.map.setBaseLayer(this.baseLayer);
  this.map.zoomToMaxExtent();
  
}

// this function is called when the document is loaded
// $(document).ready(function(){
//   window.annotation_view = new MapHub.AnnotationView(
//     <%= @map.width %>,
//     <%= @map.height %>,
//     "<%= @map.tileset_uri + '/' %>",
//   );  
// });
