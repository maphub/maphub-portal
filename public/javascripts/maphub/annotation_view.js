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
    $("#annotation_title").attr("value", "");
    $("#annotation_body").attr("value", "");
    $("#annotation_wkt_data").attr("value", wkt_data);
    
    // show the popup
    $("#slideUpBar").slideDown(function(){
      $("#annotation_title").focus();
    });
  }
  
  function controlPointAdded(evt) {
    $("#slideUpBarControlPoint").slideDown(function(){
      
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
  this.map.addLayer(this.editLayer);
  this.map.addLayer(this.annotationLayer);

  this.remoteLoadAnnotations();

  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.map.addControl(new OpenLayers.Control.MouseDefaults());
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
  
  addClickHandlers();
}

  function addClickHandlers() {
    // cancel editing an annotation
    $("#buttonCancel").click(function(){
      var response = confirm('Are you sure you want to cancel adding an annotation?');
      if (response)
        $("#slideUpBar").slideUp();
      else
        $("#annotation_title").focus();
        $("#control_point_title").focus();
        return;
    });
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

/* Loads a single annotation for this map via a JSON request */
MapHub.AnnotationView.prototype.loadSingleAnnotation = function(url) {
  var wkt_parser = new OpenLayers.Format.WKT();
  var self = this;
  
  $.getJSON(url, function(data) {
    console.log(data);
    var feature = wkt_parser.read(data.annotation.wkt_data);
    feature.annotation = data.annotation;
    self.features.push(feature);
    self.annotations.push(data.annotation);
    self.annotationLayer.addFeatures([feature]);
  });
}