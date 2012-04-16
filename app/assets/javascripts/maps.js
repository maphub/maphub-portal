//= require OpenLayers

MapHub = {}
MapHub.AnnotationView = function(width, height, zoomify_url, annotations_url, editable) {
  
  /* Callbacks for added / removed features */
  function featureSelected(evt) {
    evt.feature.tooltip = new MapHub.AnnotationTooltip(evt.feature.annotation);
    evt.feature.tooltip.show(0,0);
  }
  
  function featureUnselected(evt) {
    evt.feature.tooltip.hide();
  }
  
  // This function is called when a feature was added to the Edit layer
  function featureAdded(evt) {
    // is this a Control Point or an Annotation?
    var class_name = evt.feature.geometry.CLASS_NAME;
    if (class_name == "OpenLayers.Geometry.Point") {
      controlPointAdded(evt);
    } else {
      annotationAdded(evt);
    }
  }
  
  function annotationAdded(evt) {    
    var wkt_data = evt.feature.geometry.toString();
    var self = this;
    
    // reinitialize title and body, and copy WKT data
    $("#annotation_body").attr("value", "Add your annotation here!");
    $("#annotation_wkt_data").attr("value", wkt_data);
    
    // show the popup
    $("#modal-annotation").modal();
    $("#annotation_body").focus();
  }
  
  function controlPointAdded(evt) {
    // set x/y in form
    $("#control_point_x").attr("value", evt.feature.geometry.x);
    $("#control_point_y").attr("value", evt.feature.geometry.y);
    
    // reset the place search box and slide up panel
    $("#placeSearch").attr("value", "");
    $("#slideUpBarControlPoint").slideDown(function(){
      $("#placeSearch").focus();
    });
  }
  
  this.zoomify_width = width;
  this.zoomify_height = height;
  this.zoomify_url = zoomify_url;
  
  this.annotations_url = annotations_url;
  this.editable = editable;
  this.features = [];
  this.annotations = [];
  
  /* The zoomify layer */
  this.baseLayer = new OpenLayers.Layer.Zoomify( "Zoomify", this.zoomify_url, 
      new OpenLayers.Size( this.zoomify_width, this.zoomify_height ) );

  /* The editing controls layer */
  this.editLayer = new OpenLayers.Layer.Vector( "Editable" );
  this.editLayer.events.register("featureadded", this.editLayer, featureAdded);

  /* The annotation layer */
  this.annotationLayer = new OpenLayers.Layer.Vector( "Annotations" );
  this.annotationLayer.events.register("featureselected", this.editLayer, featureSelected);
  this.annotationLayer.events.register("featureunselected", this.editLayer, featureUnselected);

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

  // MouseDefaults is deprecated, see: http://trac.osgeo.org/openlayers/wiki/Control/MouseDefaults
  this.map.addControl(new OpenLayers.Control.Navigation());
  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.map.addControl(new OpenLayers.Control.KeyboardDefaults());

  /* Allow selection of features upon hovering */
  var select = new OpenLayers.Control.SelectFeature(
    [this.annotationLayer], { hover: true }
  );
  this.map.addControl(select);
  select.activate();

  /* Allow creation of features */
  if (editable)
    this.map.addControl(new OpenLayers.Control.EditingToolbar(this.editLayer));

  this.map.setBaseLayer(this.baseLayer);
  this.map.zoomToMaxExtent();
  
}