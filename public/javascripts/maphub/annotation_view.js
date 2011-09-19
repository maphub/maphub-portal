/* This class loads the OpenLayers view for the Zoomify tileset */
MapHub.AnnotationView = function(width, height, zoomify_url, annotations_url, editable) {
  
  this.zoomify_width = width;
  this.zoomify_height = height;
  this.zoomify_url = zoomify_url;
  this.annotations_url = annotations_url;
  this.editable = editable;
  this.features = [];
  this.annotations = [];
  
  /* Callbacks for added / removed features */
  // This function is called when an existing feature on the Annotation layer was clicked
  function featureSelected(evt) {
    var annotation = evt.feature.annotation;
  }
  
  // This function is called when a feature was added to the Edit layer
  function featureAdded(evt) {
    var wkt_data = evt.feature.geometry.toString();
    
    // reinitialize title and body, and copy WKT data
    $("#annotation_title").attr("value", "");
    $("#annotation_body").attr("value", "");
    $("#annotation_wkt_data").attr("value", wkt_data);
    
    // show the popup
    $("#slideUpBar").slideDown(function(){
      $("#annotation_title").focus();
    });
  }


  /* The zoomify layer */
  this.baseLayer = new OpenLayers.Layer.Zoomify( "Zoomify", this.zoomify_url, 
      new OpenLayers.Size( this.zoomify_width, this.zoomify_height ) );

  /* The editing controls layer */
  this.editLayer = new OpenLayers.Layer.Vector( "Editable" );
  this.editLayer.events.register("featureadded", this.editLayer, featureAdded);

  /* The annotation layer */
  this.annotationLayer = new OpenLayers.Layer.Vector( "Annotations" );
  this.annotationLayer.events.register("featureselected", this.editLayer, featureSelected);

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
  this.map.addLayer(this.editLayer);
  this.map.addLayer(this.annotationLayer);

  this.remoteLoadAnnotations();

  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.map.addControl(new OpenLayers.Control.MouseDefaults());
  this.map.addControl(new OpenLayers.Control.KeyboardDefaults());


  /* Allow selection of features */
  var select = new OpenLayers.Control.SelectFeature([this.annotationLayer]);
  this.map.addControl(select);
  select.activate();

  /* Allow creation of features */
  if (editable)
    this.map.addControl(new OpenLayers.Control.EditingToolbar(this.editLayer));

  this.map.setBaseLayer(this.baseLayer);
  this.map.zoomToMaxExtent();
}


/* Loads the annotations for this map via a JSON request */
MapHub.AnnotationView.prototype.remoteLoadAnnotations = function() {
  var wkt_parser = new OpenLayers.Format.WKT();
  var self = this;
  
  $.getJSON(this.annotations_url, function(data) { 
    $.each(data, function(key, val) {
      var feature = wkt_parser.read(val.annotation.wkt_data);
      
      feature.annotation = val.annotation;
      self.features.push(feature);
      self.annotations.push(val.annotation);
      
    });
    self.annotationLayer.addFeatures(self.features);
  });
}