//= require OpenLayers

// declare namespace
MapHub = {}

// ----------------------------------------------------------------------------

MapHub.AnnotationView = function(width, height, zoomify_url, annotations_url, control_points_url, editable, user_id) {
  
  /* Callbacks for added / removed features */
  function featureSelected(evt) {
    var class_name = evt.feature.geometry.CLASS_NAME;
    if (!evt.feature.tooltip) {
      if (class_name == "OpenLayers.Geometry.Point") {
        evt.feature.tooltip = new MapHub.ControlPointTooltip(evt.feature.control_point, self.user_id);
      } else {
        evt.feature.tooltip = new MapHub.AnnotationTooltip(evt.feature.annotation, self.user_id);
      }
      self.tooltips.push(evt.feature.tooltip);
    }
    // get the screen coordinates
    var lonlat = evt.feature.geometry.getBounds().getCenterLonLat();
    var coords = this.map.getPixelFromLonLat(lonlat);
    evt.feature.tooltip.show(coords.x - 50, coords.y);
  }
  
  function featureUnselected(evt) {
    evt.feature.tooltip.hide();
  }
  
  // This function is called when a feature was added to the Edit layer
  function featureAdded(evt) {
    
    // deactivate keyboard shortcuts
    self.keyboard_shortcuts.deactivate();
    
    // hide all tooltips
    for (var i in self.tooltips) {
      self.tooltips[i].hide();
    }
    
    // is this a Control Point or an Annotation?
    var class_name = evt.feature.geometry.CLASS_NAME;
    if (class_name == "OpenLayers.Geometry.Point") {
      controlPointAdded(evt);
    } else {
      annotationAdded(evt);
    }
  }
  
  // This function is called when an annotation was drawn
  function annotationAdded(evt) {    
    var wkt_data = evt.feature.geometry.toString();
    
    // reinitialize title and body, and copy WKT data as well as bounds
    $("#annotation_body").attr("value", "Add your annotation here!");
    $("#annotation_wkt_data").attr("value", wkt_data);
    
    $("#annotation_boundary_attributes_ne_x").attr("value", evt.feature.geometry.bounds.right);
    $("#annotation_boundary_attributes_ne_y").attr("value", evt.feature.geometry.bounds.top);
    $("#annotation_boundary_attributes_sw_x").attr("value", evt.feature.geometry.bounds.left);
    $("#annotation_boundary_attributes_sw_y").attr("value", evt.feature.geometry.bounds.bottom);
    
    // clear the existing tags
    $("#modal-annotation-tags").empty();
    $("#tagging-help").hide();
    $("#no-tags").show();
    
    // show the popup
    $("#modal-annotation").modal({
      'backdrop': 'static'
    });
    $("#annotation_body").focus();
    $("#annotation_body").select();
  }
  
  function controlPointAdded(evt) {
    var wkt_data = evt.feature.geometry.toString();
    
    // set x/y in form
    $("#control_point_wkt_data").attr("value", wkt_data);
    $("#control_point_x").attr("value", evt.feature.geometry.x);
    $("#control_point_y").attr("value", evt.feature.geometry.y);
    
    // reset the place search box and slide up panel
    $("#place-search").attr("value", "");
    $("#modal-control-point").modal({
      'backdrop': 'static'
    });
    $("#place-search").focus();
  }
  
  /* ============================================================================== */
  
  this.zoomify_width  = width;        // pixel width ...
  this.zoomify_height = height;       // ... and height of map
  this.zoomify_url    = zoomify_url;  // remote zoomify tileset
  
  this.annotations_url          = annotations_url;      // JSON request URL for annotations
  this.control_points_url       = control_points_url;   // JSON request URL for control points
  this.editable                 = editable;             // whether to show the control panel
  this.user_id                  = user_id;              // the currently logged in user ID
  this.features_annotations     = [];   // all annotation features
  this.features_control_points  = [];   // all control point features
  this.annotations              = [];   // all annotations on this map
  this.control_points           = [];   // all control points on this map
  this.tooltips                 = [];   // all tooltips on this map
  
  // ================================================================================
  
  var annotationStyleMap = new OpenLayers.StyleMap({
    'default': new OpenLayers.Style({
      'strokeColor': "#cc4400",
      'fillOpacity': "0.4",
      'fillColor': "#cc4400"
    }),
    'select': new OpenLayers.Style({
      'strokeColor': "#ff0000",
    }),
    'temporary': new OpenLayers.Style({
      'strokeColor': "#005580",
      'fillColor': "#00A9FF",
      'fillOpacity': "0.4",
    })
  });
  
  var controlPointStyleMap = new OpenLayers.StyleMap({
    'default': new OpenLayers.Style({
      'externalGraphic': "/assets/openlayers/pin.png",
      'graphicWidth': '15',
      'graphicWidth': '25',
      'graphicXOffset': -13,
      'graphicYOffset': -25
    }),
    'select': new OpenLayers.Style({
      'externalGraphic': "/assets/openlayers/pin.png",
      'graphicWidth': '15',
      'graphicWidth': '25',
      'graphicXOffset': -13,
      'graphicYOffset': -25
    }),
    'temporary': new OpenLayers.Style({
      'externalGraphic': "/assets/openlayers/pin.png",
      'graphicWidth': '15',
      'graphicWidth': '25',
      'graphicXOffset': -13,
      'graphicYOffset': -25
    })
  });
  
  // ================================================================================
  
  /* The zoomify layer */
  this.baseLayer = new OpenLayers.Layer.Zoomify(
    "Zoomify", 
    this.zoomify_url,
    new OpenLayers.Size( this.zoomify_width, this.zoomify_height ),
    { displayInLayerSwitcher: false }
  );

  /* The editing controls layer */
  this.editLayer = new OpenLayers.Layer.Vector(
    "Editable", 
    { styleMap: annotationStyleMap, displayInLayerSwitcher: false }
  );
  this.editLayer.events.register("featureadded", this.editLayer, featureAdded);
  
  this.controlPointEditLayer = new OpenLayers.Layer.Vector( 
    "Control Point Editable", 
    { styleMap: controlPointStyleMap, displayInLayerSwitcher: false }
  );
  this.controlPointEditLayer.events.register("featureadded", this.controlPointEditLayer, featureAdded);
  
  // if the close button is clicked, we remove all temporary features
  $("a.close").click(function() {
    self.editLayer.removeAllFeatures();
    self.controlPointEditLayer.removeAllFeatures();
  });
  
  
  /* The annotation layer */
  this.annotationLayer = new OpenLayers.Layer.Vector(
    "Annotations", 
    { styleMap: annotationStyleMap }
  );
  
  /* The control points layer */
  this.controlPointsLayer = new OpenLayers.Layer.Vector( 
    "Control Points", 
    { styleMap: controlPointStyleMap }
  );
  

  /* Display options */
  var bounds = new OpenLayers.Bounds(0, 0, this.zoomify_width, this.zoomify_height)
  var options = {
      controls: [], 
      maxExtent: bounds,
      restrictedExtent: bounds,
      maxResolution: Math.pow(2, this.baseLayer.numberOfTiers-1),
      numZoomLevels: this.baseLayer.numberOfTiers,
      units: 'pixels'
  };

  this.map = new OpenLayers.Map("viewer", options);

  // add all layers to the map
  this.map.addLayer(this.baseLayer);
  this.map.addLayer(this.editLayer);
  this.map.addLayer(this.controlPointEditLayer);
  this.map.addLayer(this.annotationLayer);
  this.map.addLayer(this.controlPointsLayer);


  // remotely load already existing annotations and control points via JSON
  this.remoteLoadAnnotations();
  this.remoteLoadControlPoints();

  // add autocomplete
  this.initAutoComplete();

  // MouseDefaults is deprecated, see: http://trac.osgeo.org/openlayers/wiki/Control/MouseDefaults
  this.map.addControl(new OpenLayers.Control.Navigation());
  this.map.addControl(new OpenLayers.Control.MousePosition());
  this.map.addControl(new OpenLayers.Control.PanZoomBar());
  this.keyboard_shortcuts = new OpenLayers.Control.KeyboardDefaults();
  this.map.addControl(this.keyboard_shortcuts);
  
  this.map.addControl(new OpenLayers.Control.LayerSwitcher(
    {'div':OpenLayers.Util.getElement('layerswitcher')})
    );
  
  // ================================================================================

  var select = new OpenLayers.Control.SelectFeature(
    [this.annotationLayer, this.controlPointsLayer], { 
      hover: true,
      renderIntent: "temporary"
      }
  );
  this.map.addControl(select);
  select.activate();
  
  this.annotationLayer.events.on({
    "featureselected": featureSelected,
    "featureunselected": featureUnselected
  });
  
  this.controlPointsLayer.events.on({
    "featureselected": featureSelected,
    "featureunselected": featureUnselected
  });
  
  
  // ================================================================================
  
  /* Allow creation of features */
  // http://stackoverflow.com/questions/10572005/
  if (editable) {
    this.drawControls = {
        point: new OpenLayers.Control.DrawFeature(this.controlPointEditLayer,
            OpenLayers.Handler.Point),
        line: new OpenLayers.Control.DrawFeature(this.editLayer,
            OpenLayers.Handler.Path),
        polygon: new OpenLayers.Control.DrawFeature(this.editLayer,
            OpenLayers.Handler.Polygon),
        box: new OpenLayers.Control.DrawFeature(this.editLayer,
            OpenLayers.Handler.RegularPolygon, {
                handlerOptions: {
                    sides: 4,
                    irregular: true
                }
            }
        )
    };
    
    // add controls to map
    for(var key in this.drawControls) {
        this.map.addControl(this.drawControls[key]);
    }
    
    // hide the types for an annotation
    $("#control-toggle-annotation-types").hide();
    $("#control-toggle-annotation").click(function() {
      $("#control-toggle-annotation-types").slideDown();
    });
    $("#control-toggle-control-point, #control-toggle-navigate").click(function(){
      $("#control-toggle-annotation-types").slideUp();
    });
    
    // check for toggled types
    var self=this;
    $("#control-toggle button").click(function(){
      for(key in self.drawControls) {
          var control = self.drawControls[key];
          if(this.value == key) {
              control.activate();
          } else {
              control.deactivate();
          }
      }      
    });
    
  }
  
  // ================================================================================
  
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
      self.features_annotations.push(feature);
      self.annotations.push(val);
    });
    self.annotationLayer.addFeatures(self.features_annotations);
  });
}

/* Loads the annotations for this map via a JSON request */
MapHub.AnnotationView.prototype.remoteLoadControlPoints = function() {
  var wkt_parser = new OpenLayers.Format.WKT();
  var self = this;
  
  $.getJSON(this.control_points_url, function(data) { 
    $.each(data, function(key, val) {
      var feature = wkt_parser.read(val.wkt_data);
      feature.control_point = val;
      self.features_control_points.push(feature);
      self.control_points.push(val);
    });
    self.controlPointsLayer.addFeatures(self.features_control_points);
  });
}



// ----------------------------------------------------------------------------

// Creates a new tooltip div for that annotation
MapHub.AnnotationTooltip = function(annotation, user_id) {
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
MapHub.AnnotationTooltip.prototype.show = function(x, y) {
  this.div.css("left", x);
  this.div.css("top", y);
  this.div.show();
}

// hide an annotation tooltip if it already exists
MapHub.AnnotationTooltip.prototype.hide = function() {
  this.div.hide();
}


// ----------------------------------------------------------------------------

// Creates a new tooltip div for that control point
MapHub.ControlPointTooltip = function(control_point, user_id) {
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
MapHub.ControlPointTooltip.prototype.show = function(x, y) {
  this.div.css("left", x);
  this.div.css("top", y);
  this.div.show();
}

// hide a control point tooltip if it already exists
MapHub.ControlPointTooltip.prototype.hide = function() {
  this.div.hide();
}

// ----------------------------------------------------------------------------

MapHub.TaggingView = function(callback_url, timeout) {
  this.callback_url = callback_url;
  this.timeout = timeout;
  this.tags = new Array();
  var self = this; // store the function for later
  
  // after 1000 ms of waiting, create the tags
  $("#annotation_body").keyup(function(){
    $(this).doTimeout('annotation-timeout', self.timeout, function(){
      
      // get text to submit to controller
      var text = encodeURIComponent($("#annotation_body").val().replace(/[^\w\s]/gi, ''));
      if(!(text === "") || !(text == "Add your annotation here!")) {
        
        // main request sent to controller
        var request = self.callback_url           + "?"
          + "text="             + text            + "&" 
          + "annotation[boundary][ne_x]="   + $("#annotation_boundary_attributes_ne_x").val()  + "&"
          + "annotation[boundary][ne_y]="   + $("#annotation_boundary_attributes_ne_y").val()  + "&"
          + "annotation[boundary][sw_x]="   + $("#annotation_boundary_attributes_sw_x").val()  + "&"
          + "annotation[boundary][sw_y]="   + $("#annotation_boundary_attributes_sw_y").val()
          ;
        
        $("#no-tags").hide();
        $("#loading-tags").show();
        
        // fetch tags for this text
        $.getJSON(request, function(data) {
          
          $("#loading-tags").hide();
          $("#tagging-help").fadeIn("slow");
          
          // iterate over every tag received
          $.each(data, function(key, val) {
            // returned tags are in val, with their attributes
            var label = val.label;
            var dbpedia_uri = val.dbpedia_uri;
            var description = val.description;
            
            // if the tag doesn't exist yet
            if (self.tags[label] === undefined) {
              
              // create new tag element
              var tag = $(document.createElement('span'));
              // set style (label)
              tag.attr("class", "label label-neutral");
              tag.text(label);
              // link it
              var linked_tag = $(document.createElement('a'));
              //linked_tag.attr("href", dbpedia_uri);
              //linked_tag.attr("href", "#");
              //linked_tag.attr("target", "_blank");
              linked_tag.attr("rel", "tooltip");
              linked_tag.attr("title", description);
              linked_tag.html(tag)
              // append to the form
              linked_tag.appendTo($("#modal-annotation-tags"));


              // // create hidden input fields to pass on data
              var input_container = $(document.createElement('div'));
              input_container.attr("class", "tag-fields");

              var input_label = $(document.createElement('input'));
              input_label.attr("type", "text");
              input_label.css("display", "none");
              input_label.attr("name", "label[]");
              input_label.attr("value", label);
              input_label.appendTo(input_container);

              var input_dbpedia_uri = $(document.createElement('input'));
              input_dbpedia_uri.attr("type", "text");
              input_dbpedia_uri.css("display", "none");
              input_dbpedia_uri.attr("name", "dbpedia_uri[]");
              input_dbpedia_uri.attr("value", dbpedia_uri);
              input_dbpedia_uri.appendTo(input_container);

              var input_description = $(document.createElement('input'));
              input_description.attr("type", "text");
              input_description.css("display", "none");
              input_description.attr("name", "description[]");
              input_description.attr("value", description);
              input_description.appendTo(input_container);

              var input_status = $(document.createElement('input'));
              input_status.attr("type", "text");
              input_status.css("display", "none");
              input_status.attr("name", "status[]");
              input_status.attr("value", "neutral");
              input_status.appendTo(input_container);

              input_container.appendTo($("#modal-annotation-tags"));

              // add the tags objects to the javascript view 
              // so we can manipulate them
              self.tags[label] = val;

              // toggle accepted / rejected / neutral
              tag.click(function() {
                if ($(this).hasClass("label-neutral")) {
                  $(this).removeClass("label-neutral").addClass("label-success");
                  self.tags[label].status = "accepted";
                  input_status.attr("value", "accepted");
                } else if ($(this).hasClass("label-success")) {
                  $(this).removeClass("label-success").addClass("label-important");
                  self.tags[label].status = "rejected";
                  input_status.attr("value", "rejected");
                } else if ($(this).hasClass("label-important")) {
                  $(this).removeClass("label-important").addClass("label-neutral");
                  self.tags[label].status = "neutral";
                  input_status.attr("value", "neutral");
                }
              }); // end click handler for tags
            } // end if tag exists
            
          }); // end each iteration for returned tags
        }); // end get JSON request
      } // end check whether input text is empty
    }); // end timeout function
  }); // end keyup function
} // end tagging view

// resets the internal structure of the tagging view, i.e. the tags it remembered
MapHub.TaggingView.prototype.reset = function() {
  this.tags = new Array();
}