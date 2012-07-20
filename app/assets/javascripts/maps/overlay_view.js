//= require maps/overlays/ext_draggable_object
//= require maps/overlays/map
//= require maps/overlays/tile_overlay
//= require maps/overlays/alpha_overlay

var activeInfoWindow;
this.toggleState = 1; //current visibility of Google Maps annotations
this.annotations_array = []; //stores all Google Maps annotations for this map
this.annotations_url_gmap;
this.map_gmap;

maphub.OverlayView = function(parameters) {
  if (parameters) {
    google.load('maps', '3', {
      callback: function() {
        var map = new maphub.Map(parameters);
        map.render(document.getElementById('overlay_viewer'));
        map_gmap = map;
        annotations_url_gmap = parameters.annotations_url;
        makeGoogleAnnotations(map_gmap, annotations_url_gmap);
      },
      other_params: "sensor=true"
    }); 
  }
}

//Generates the necessary information to put annotations on the Google Maps Overlay
function makeGoogleAnnotations(map, annotations_url){
  $.getJSON(annotations_url, function(data) {
    $.each(data, function(key, val) {
      annotation_type = val.wkt_data[0]; //P or L for POLYGON or LINESTRING
      addGoogleAnnotation(map["googleMap"], val.google_maps_annotation, 
      annotation_type, val.body);
    });
  });
}

//Makes sure that any new annotations are added to the Google Maps Overlay
function refreshGoogleAnnotation()
{
  $.each(this.annotations_array, function(){
    this.setMap(null);
    });
    makeGoogleAnnotations(this.map_gmap, this.annotations_url_gmap);
}

//Takes a map and string of lat/lng points and adds the given annotation to
//the map
function addGoogleAnnotation(map, points, type, annotation_text)
{
  var paths = [];
  var pointpairs = points.split(",");
  $.each(pointpairs, function(){
    coords = this.split(" ");
    paths.push(new google.maps.LatLng(coords[0], coords[1]));
  });
  
  //Annotation is a POLYGON
  if(type == "P"){
  var shape = new google.maps.Polygon({
    paths: paths,
    strokeColor: '#cc4400',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#cc4400',
    fillOpacity: 0.4
  });
  }
  //Annotation is a LINESTRING
  else if(type == "L"){
    var shape = new google.maps.Polyline({
      path: paths,
      strokeColor:'#cc4400',
      strokeOpacity: 1.0,
      strokeWeight:3
    });
  }
  //Add an infoWindow to the annotation containing its text
  var infoWindow = new google.maps.InfoWindow({
    content: annotation_text,
    position: new google.maps.LatLng(50, 50),
    maxWidth: 300
  });
  eventPolygonClick = google.maps.event.addListener(shape, 'click', function(event) { 
   var marker = new google.maps.Marker({
    position: event.latLng
   });
   if(activeInfoWindow)
    activeInfoWindow.close();
   infoWindow.open(map, marker);
   activeInfoWindow = infoWindow;
  });

  shape.setMap(map);
  annotations_array.push(shape);
}

//Toggles the visibility of the Google Maps annotations
function toggleGoogleAnnotations()
{
  $.each(this.annotations_array, function(){
    if(toggleState ==1){
      this.setVisible(false);
      if(activeInfoWindow)
        activeInfoWindow.close();
    }
    else{
      this.setVisible(true);
    }
  });
  
  toggleState = (toggleState==1) ? 0:1;
  
}
