//= require maps/overlays/ext_draggable_object
//= require maps/overlays/map
//= require maps/overlays/tile_overlay
//= require maps/overlays/alpha_overlay

maphub.OverlayView = function(parameters) {
  if (parameters) {
    google.load('maps', '3', {
      callback: function() {
        var map = new maphub.Map(parameters);
        map.render(document.getElementById('overlay_viewer'));
        //JSON request to get lat/lng of map's annotations and add them to Google Map
        $.getJSON(parameters.annotations_url, function(data) {
          $.each(data, function(key, val) {
          annotation_type = val.wkt_data[0]; //P or L for POLYGON or LINESTRING
            addGoogleAnnotation(map["googleMap"], val.google_maps_annotation, 
            annotation_type, val.body);
          });
        });
      },
      other_params: "sensor=true"
    }); 
  }
}

//Takes a map and string of lat/lng points and adds the given annotation to
//the given map
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
      strokeWeight:2
    });
  }
  //Add an infoWindow to the annotation containing its text
  var infowindow = new google.maps.InfoWindow({
    content: annotation_text,
    position: new google.maps.LatLng(50, 50),
    maxWidth: 300
  });
  eventPolygonClick = google.maps.event.addListener(shape, 'click', function(event) { 
   var marker = new google.maps.Marker({
    position: event.latLng
   }); 
   infowindow.open(map, marker);
  });

  shape.setMap(map);
}
