//= require OpenLayers

// declare namespace
MapHub = {}

// ----------------------------------------------------------------------------

MapHub.AnnotationView = function(width, height, zoomify_url, annotations_url, control_points_url, editable) {
  
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
    $("#annotation_body").select();
  }
  
  function controlPointAdded(evt) {
    // set x/y in form
    $("#control_point_x").attr("value", evt.feature.geometry.x);
    $("#control_point_y").attr("value", evt.feature.geometry.y);
    
    // reset the place search box and slide up panel
    $("#place-search").attr("value", "");
    $("#modal-control-point").modal();
    $("#place-search").focus();
  }
  
  this.zoomify_width = width;
  this.zoomify_height = height;
  this.zoomify_url = zoomify_url;
  
  this.annotations_url = annotations_url;
  this.control_points_url = control_points_url;
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
  this.annotationLayer.events.register("featureselected", this.annotationLayer, featureSelected);
  this.annotationLayer.events.register("featureunselected", this.annotationLayer, featureUnselected);

  /* Display options */
  var options = {
      controls: [], 
      maxExtent: new OpenLayers.Bounds(0, 0, this.zoomify_width, this.zoomify_height),
      maxResolution: Math.pow(2, this.baseLayer.numberOfTiers-1),
      numZoomLevels: this.baseLayer.numberOfTiers,
      units: 'pixels'
  };

  this.map = new OpenLayers.Map("viewer", options);

  // add all layers to the map
  this.map.addLayer(this.baseLayer);
  this.map.addLayer(this.editLayer);
  this.map.addLayer(this.annotationLayer);


  // remotely load already existing annotations via JSON
  this.remoteLoadAnnotations();

  // add autocomplete
  this.initAutoComplete();

  // MouseDefaults is deprecated, see: http://trac.osgeo.org/openlayers/wiki/Control/MouseDefaults
  this.map.addControl(new OpenLayers.Control.Navigation());
  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.map.addControl(new OpenLayers.Control.KeyboardDefaults());

  /* Allow selection of features upon hovering */
  var highlight = new OpenLayers.Control.SelectFeature(
    [this.annotationLayer], { 
      hover: true,
      highlightOnly: true
      }
  );
  var select = new OpenLayers.Control.SelectFeature(
    [this.annotationLayer], { 
      clickout: true,
      }
  );
  this.map.addControl(highlight);
  this.map.addControl(select);
  highlight.activate();
  select.activate();

  /* Allow creation of features */
  if (editable)
    this.map.addControl(new OpenLayers.Control.EditingToolbar(this.editLayer));

  this.map.setBaseLayer(this.baseLayer);
  this.map.zoomToMaxExtent();
  
}

// ----------------------------------------------------------------------------

MapHub.AnnotationView.prototype.initAutoComplete = function() {
  $('input#place-search').autocomplete({
      source: function( request, response ) {
          $.ajax({
            url: "http://ws.geonames.org/searchJSON",
            dataType: "jsonp",
            data: {
              featureClass: "P",
              style: "full",
              maxRows: 12,
              name_startsWith: request.term
            },
            success: function( data ) {
              response( $.map( data.geonames, function( item ) {
                return {
                  label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
                  value: item.name,
                  short_name: item.name,
                  lat: item.lat,
                  lng: item.lng,
                  geonameId: item.geonameId
                }
              }));
            }
          });
        },
        minLength: 2,
        select: function( event, ui ) {
          // what to do when it's selected
          $("#control_point_name").attr("value", ui.item.short_name);
          $("#control_point_geonames_label").attr("value", ui.item.label);
          $("#control_point_lat").attr("value", ui.item.lat);
          $("#control_point_lng").attr("value", ui.item.lng);
          $("#control_point_geonames_id").attr("value", ui.item.geonameId);
        },
        open: function() {
          $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
          $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });
}

// ----------------------------------------------------------------------------

/* Loads the annotations for this map via a JSON request */
MapHub.AnnotationView.prototype.remoteLoadAnnotations = function() {
  var wkt_parser = new OpenLayers.Format.WKT();
  var self = this;
  
  $.getJSON(this.annotations_url, function(data) { 
    $.each(data, function(key, val) {
      var feature = wkt_parser.read(val.wkt_data);
      feature.annotation = val;
      self.features.push(feature);
      self.annotations.push(val);
    });
    self.annotationLayer.addFeatures(self.features);
  });
}


// ----------------------------------------------------------------------------

MapHub.AnnotationTooltip = function(annotation) {
  this.div = document.createElement("div");
  this.div.setAttribute("class", "annotation-tooltip");
  
  this.div_body = document.createElement("div");
  this.div_body.setAttribute("class", "annotation-tooltip-body");
  this.div_body.innerHTML = annotation.body;
  this.div.appendChild(this.div_body); 
  
  document.getElementById("annotation-selected").appendChild(this.div);
}

MapHub.AnnotationTooltip.OFFSET_X = 0;
MapHub.AnnotationTooltip.OFFSET_Y = 0;

MapHub.AnnotationTooltip.prototype.show = function(x, y) {
  this.div.style.left = x + MapHub.AnnotationTooltip.OFFSET_X + "px";
  this.div.style.top = y + MapHub.AnnotationTooltip.OFFSET_Y + "px";
  this.div.style.display = "block";
}

MapHub.AnnotationTooltip.prototype.hide = function() {
  this.div.style.display = "none";
}

MapHub.AnnotationTooltip.prototype.remove = function() {
  // TODO
}

// ----------------------------------------------------------------------------

MapHub.TaggingView = function(callback_url) {
  this.callback_url = callback_url;
  var self = this;
  
  $("#annotation_body").keyup(function(){
    $(this).doTimeout('annotation-timeout', 500, function(){
      // fetch tags for this text
      var text = encodeURI($("#annotation_body").val());
      if(!(text === "")) {
        var request = self.callback_url + text;
        $.getJSON(request, function(data) {
          $("#modal-annotation-tags").empty();
          $.each(data, function(key, val) {
            // returned tags are in val, with their attributes
            var dbpedia_uri = val.dbpedia_uri;
            var label = val.label;
            
            // create new tag element
            var tag = $(document.createElement('span'));
            // set style (label)
            tag.attr("class", "label");
            tag.text(label);
            // link it
            var linked_tag = $(document.createElement('a'));
            linked_tag.attr("href", dbpedia_uri);
            linked_tag.attr("target", "_blank");
            linked_tag.html(tag)
            // append to the form
            linked_tag.appendTo($("#modal-annotation-tags"));
            
            // create hidden input fields
            var input_label = $(document.createElement('input'));
            input_label.attr("type", "text");
            input_label.css("display", "none");
            input_label.attr("name", "label[]");
            input_label.attr("value", label);
            input_label.appendTo($("#modal-annotation-tags"));
            
            var input_dbpedia_uri = $(document.createElement('input'));
            input_dbpedia_uri.attr("type", "text");
            input_dbpedia_uri.css("display", "none");
            input_dbpedia_uri.attr("name", "dbpedia_uri[]");
            input_dbpedia_uri.attr("value", dbpedia_uri);
            input_dbpedia_uri.appendTo($("#modal-annotation-tags"));
          });
        }); 
      }
    });
  });
}