/**
 * Loosely based on Gavin Harriss' maphub.TileOverlay (http://www.gavinharriss.com/)
 */
maphub.TileOverlay = function(parameters) {
	this.tiles = {};
	this.tileSize = parameters.tileSize;
}

maphub.TileOverlay.prototype.getTile = function(point, zoomLevel, container) {
	console.log("maphub.TileOverlay.prototype.getTile");

	/*
	 * If the tile already exists, use it.
	 */
	var tileID = zoomLevel + '-' + point.x + '-' + point.y;
	var div = null;
	if (typeof this.tiles[tileID] == "undefined") {
		/*
		 * The tile doesn't exist, create it.
		 */
		console.log("Creating new tile for " + tileID);
		div = container.createElement('div');
		div.style.width = this.tileSize.width + 'px';
		div.style.height = this.tileSize.height + 'px';

//		var ymax = 1 << zoomLevel;
//		var y = ymax - point.y - 1;
//		div.style.background = 'url(/images/tiles/ct002033/google/'+zoomLevel+'/'+point.x+'/'+y+'.png) no-repeat';
		var tileCoordinates = this.getTileUrlCoord(point, zoomLevel);
		div.style.background = 'url(/images/tiles/ct002033/google/'+zoomLevel+'/'+tileCoordinates.x+'/'+tileCoordinates.y+'.png) no-repeat';
		
		this.tiles[tileID] = div;
	} else {
		/*
		 * The tile already exists, use it.
		 */
		console.log("Found existing tile for " + tileID);
		div = this.tiles[tileID];
	}

	return div;
}

maphub.TileOverlay.prototype.latLngToTile = function(latLng, z) {
	var projection = this.map.getProjection();
	var worldCoordinate = projection.fromLatLngToPoint(latLng);
	var pixelCoordinate = new google.maps.Point(worldCoordinate.x * Math.pow(2, z), worldCoordinate.y * Math.pow(2, z));
	var tileCoordinate = new google.maps.Point(Math.floor(pixelCoordinate.x / this.tileSize.width), Math.floor(pixelCoordinate.y / this.tileSize.height));
	return tileCoordinate;
}

maphub.TileOverlay.prototype.getTileUrlCoordFromLatLng = function(latlng, zoom) {
	return this.getTileUrlCoord(this.latLngToTile(latlng, zoom), zoom)
}

maphub.TileOverlay.prototype.getTileUrlCoord = function(coord, zoom) {
	var tileRange = 1 << zoom;
	var y = tileRange - coord.y - 1;
	var x = coord.x;
	if (x < 0 || x >= tileRange) {
		x = (x % tileRange + tileRange) % tileRange;
	}
	return new google.maps.Point(x, y);
}
