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
maphub.Map=function(e){this.id=e.id,typeof e["deleteHiddenTiles"]=="undefined"?this.deleteHiddenTiles=!1:this.deleteHiddenTiles=e.deleteHiddenTiles,typeof e["tileSize"]=="undefined"?this.tileSize=new google.maps.Size(256,256):this.tileSize=e.tileSize,this.mapBounds=new google.maps.LatLngBounds(new google.maps.LatLng(e.sw_lat,e.sw_lng),new google.maps.LatLng(e.ne_lat,e.ne_lng)),this.overlayTilesetUri=e.overlay_tileset_uri,this.minTileset=e.min_tileset,this.maxTileset=e.max_tileset,this.zoom=Math.floor(e.min_tileset+(e.max_tileset-e.min_tileset)/2)},maphub.Map.prototype.render=function(e){var t={center:this.mapBounds.getCenter(),mapTypeId:google.maps.MapTypeId.ROADMAP,streetViewControl:!1,zoom:this.zoom,minZoom:this.minTileset,maxZoom:this.maxTileset};this.googleMap=new google.maps.Map(e,t);var n=new maphub.AlphaOverlay({map:this,tileSize:this.tileSize,overlay_tileset_uri:this.overlayTilesetUri});this.googleMap.overlayMapTypes.push(n)},maphub.Map.toString=function(){return"Map<id="+this.id+">"};