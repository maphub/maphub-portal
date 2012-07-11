/**
 * An overlay layer that consists of image tiles.
 * 
 * Loosely based on Gavin Harriss' TileOverlay (http://www.gavinharriss.com/)
 * 
 * @param {Object} parameters Configuration parameters. Required parameters are:
 *   map: The maphub.Map instance on which this overlay will exist.
 *   tileSize: The google.maps.Size of the tiles on which this overlay is based.
 */
maphub.TileOverlay = function(parameters) {
  this.tiles = {};
  if (parameters) {
    this.map = parameters.map;
    this.tileSize = parameters.tileSize;
    this.url = parameters.overlay_tileset_uri;
    
    /*
     * Get a reference to ourselves for use in callbacks.
     */
    var self = this;
    
    /*
     * If requested, enable the deletion of tiles that aren't in the viewer.
     */
    if (this.map['deleteHiddenTiles']) {
      google.maps.event.addListener(this.map.googleMap, 'idle', function () {
        self.deleteHiddenTiles();
      });
    }
  }
}



/*
 * Delete tiles that are not visible in the viewport. This helps keep memory
 * overhead low, which is noticable on wimpy systems like phones and implanted
 * tracking microchi--er--just phones.
 */
maphub.TileOverlay.prototype.deleteHiddenTiles = function() {
//  console.log("Deleting hidden tiles.");
  /*
   * First, set some variables to extract the boundaries of the current map.
   */
  var bounds = this.map.googleMap.getBounds();
  var zoom = this.map.googleMap.getZoom();
  var ne = bounds.getNorthEast();
  var sw = bounds.getSouthWest();
  var neTile = this.latLngToTile(ne, zoom);
  var swTile = this.latLngToTile(sw, zoom);
  var nwTile = new google.maps.Point(swTile.x, neTile.y);
  var seTile = new google.maps.Point(neTile.x, swTile.y);
//  console.log("New tiles: "+neTile+","+swTile+","+nwTile+","+seTile);

  /*
   * Determine the boundaries of the viewport in terms of tile coordinates.
   */
  var minX = swTile.x;
  var maxX = neTile.x;
  var maxY = swTile.y;
  var minY = neTile.y;
//  console.log('Deleting tiles outside '+minX+','+minY+' and '+maxX+','+maxY);

  /*
   * Create an object in which we will store the tiles we want to keep. This
   * will eventually be assigned to this.tiles.
   */
  var tilesToKeep = {};
  
  /*
   * Loop through all current tiles.
   */
  for (var tileID in this.tiles) {
    /*
     * Loop through all visible x,y tile coordinates.
     */
    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        var tmpTileID = zoom+'-'+x+'-'+y;
        if (tmpTileID == tileID) {
//          console.log(tileID+" matches");
          /*
           * This tile is visible, keep it.
           */
          tilesToKeep[tileID] = this.tiles[tileID];
        }
      }
    }
  }
  
  this.tiles = tilesToKeep;
//  console.log('Tiles after deletion:');
//  console.log(this.tiles);
  return;
}



/*
 * Retrieve the specified tile and creater a DIV element in the specified
 * container.
 *
 * @param point The tile coordinate from Google, which doesn't match up with the
 *   overlay map's coordinates due to different projections.
 * @param zoomLevel The current zoom level.
 * @param container The container in which the tile should be created.
 * @return The DIV element that was created.
 */
maphub.TileOverlay.prototype.getTile = function(point, zoomLevel, container) {
//  console.log("maphub.TileOverlay.prototype.getTile");
  
  /*
   * If the tile already exists, use it.
   */
  var tileID = zoomLevel + '-' + point.x + '-' + point.y;
  var div = null;
  if (typeof this.tiles[tileID] == "undefined") {
//    console.log("Creating new tile for " + tileID);
    /*
     * The tile doesn't exist, create it. First, find out what the map's
     * tile coordinates (not lat/lng or x/y) are. Since the map uses a flat
     * x,y projection, and Google uses a spherical Mercator projection, we
     * need to use the map's metadata to find out which tile is the correct
     * tile to use for the specified Google map tile.
     */
     var tileCoordinates = this.getTileUrlCoord(point, zoomLevel);

    /*
     * Second, create the actual HTML element and set the background image to
     * the tile's image.
     */
    div = container.createElement('div');
    div.style.width = this.tileSize.width + 'px';
    div.style.height = this.tileSize.height + 'px';
    div.style.background = 'url('+this.url+'/'+zoomLevel+'/'+tileCoordinates.x+'/'+tileCoordinates.y+'.png) no-repeat';
//    div.style.border = '1px solid #888';
//    div.innerHTML = '('+point.x+','+point.y+')';

    /*
     * Cache the tile for quick retrieval later.
     */
    this.tiles[tileID] = div;
//    console.log('Tiles:');
//    console.log(this.tiles);
  } else {
    /*
     * The tile already exists, use it.
     */
    console.log("Found existing tile for " + tileID);
    div = this.tiles[tileID];
  }

  return div;
}



/*
 * Convert the specified lat/lng pair and zoom level to a tile coordinate. This
 * takes into account the fact that the MapHub map is using a different (flat)
 * projection than the Google map (Mercator).
 */
maphub.TileOverlay.prototype.latLngToTile = function(latLng, z) {
  var projection = this.map.googleMap.getProjection();
  var worldCoordinate = projection.fromLatLngToPoint(latLng);
  var pixelCoordinate = new google.maps.Point(worldCoordinate.x * Math.pow(2, z), worldCoordinate.y * Math.pow(2, z));
  var tileCoordinate = new google.maps.Point(Math.floor(pixelCoordinate.x / this.tileSize.width), Math.floor(pixelCoordinate.y / this.tileSize.height));
//  console.log("lLTT: "+worldCoordinate+" "+pixelCoordinate+" "+tileCoordinate);
  return tileCoordinate;
}


maphub.TileOverlay.prototype.getTileUrlCoordFromLatLng = function (latlng, zoom) {
  return this.getTileUrlCoord(this.latLngToTile(latlng, zoom), zoom)
}

maphub.TileOverlay.prototype.getTileUrlCoord = function(coord, zoom) {
//  console.log('maphub.TileOverlay.prototype.getTileUrlCoord: '+coord+', '+zoom);
  var tileRange = 1 << zoom;
  var y = tileRange - coord.y - 1;
  var x = coord.x;
  if (x < 0 || x >= tileRange) {
    x = (x % tileRange + tileRange) % tileRange;
  }
  return new google.maps.Point(x, y);
}

maphub.TileOverlay.prototype.toString = function() {
  return 'TileOverlay<map='+this.map+', tileSize='+this.tileSize+'>';
}
