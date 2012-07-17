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
      },
      other_params: "sensor=true"
    }); 
  }
}
