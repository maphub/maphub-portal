//= require maps/overlays/ext_draggable_object
//= require maps/overlays/map
//= require maps/overlays/tile_overlay
//= require maps/overlays/alpha_overlay

maphub.OverlayView = function(id, ne_lat, ne_lng, sw_lat, sw_lng, overlay_tileset_uri) {
  google.load('maps', '3', {
    callback: function() {
      var map = new maphub.Map({
        deleteHiddenTiles: true,
        id: id,
        ne_lat: ne_lat,
        ne_lng: ne_lng,
        sw_lat: sw_lat,
        sw_lng: sw_lng,
        overlay_tileset_uri: overlay_tileset_uri
      });
      map.render(document.getElementById('overlay_viewer'));
    },
    other_params: "sensor=true&libraries=drawing"
  });
}