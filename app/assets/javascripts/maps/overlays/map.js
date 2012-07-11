/**
 * Map represents a map. Go figure. Valid parameters are:
 *   id: A required integer indicating the ID of the map.
 *   deleteHiddenTiles: A boolean to indicate if the map should delete tiles
 *     that are not visible in the viewport. Defaults to false.
 *   tileSize: The tile size (as google.maps.Size). Defaults to 256x256.
 * 
 * @param parameters
 *           An Object containing key-value pairs of parameters.
 */
maphub.Map = function(parameters) {
  this.id = parameters.id;
  
  if (typeof parameters['deleteHiddenTiles'] == 'undefined') {
    this.deleteHiddenTiles = false;
  } else {
    this.deleteHiddenTiles = parameters.deleteHiddenTiles;
  }

  if (typeof parameters['tileSize'] == 'undefined') {
    this.tileSize = new google.maps.Size(256,256);
  } else {
    this.tileSize = parameters['tileSize'];
  }
  
  this.mapBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(parameters.sw_lat, parameters.sw_lng),
    new google.maps.LatLng(parameters.ne_lat, parameters.ne_lng)
  );
  
  this.overlayTilesetUri = parameters.overlay_tileset_uri;
  this.maxTileset = parameters.max_tileset;
  
  document.map = this;
};



/*
 * Render the map visualization to the specified container element.
 */
maphub.Map.prototype.render = function(container) {
    
    var mapOptions = {
      center: this.mapBounds.getCenter(),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
      zoom: 5
    };
    this.googleMap = new google.maps.Map(container, mapOptions);
    
    /*
     * Create our alpha-enabled overlay.
     */    
    var overlay = new maphub.AlphaOverlay({
      map: this,
      tileSize: this.tileSize,
      overlay_tileset_uri: this.overlayTilesetUri
    });
    
    /*
     * Add our overlay to the map.
     */
    this.googleMap.overlayMapTypes.push(overlay);
};

maphub.Map.toString = function() {
  return 'Map<id='+this.id+'>';
}
