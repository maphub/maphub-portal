define({});

/**
 * An overlay layer that consists of image tiles.
 * 
 * Loosely based on Gavin Harriss' TileOverlay (http://www.gavinharriss.com/)
 * 
 * @param {Object} parameters Configuration parameters. Required parameters are:
 * 	map ({maphub.Map}): The maphub.Map instance on which this overlay will exist.
 * 	tileSize ({google.maps.Size}): The size of the tiles on which this overlay is based.
 */
maphub.TileOverlay = function(parameters) {
	this.tiles = {};
	if (parameters) {
		this.map = parameters.map;
		this.tileSize = parameters.tileSize;
	}
	
	console.log("Created "+this);
}

maphub.TileOverlay.prototype.getTile = function(point, zoomLevel, container) {
	console.log("maphub.TileOverlay.prototype.getTile");

	var xynw = new google.maps.Point(point.x*this.tileSize.width, point.y*this.tileSize.height);
	var xyse = new google.maps.Point((point.x+1)*this.tileSize.width, (point.y+1)*this.tileSize.height);
	
	console.log("Coord for "+point+': '+xynw+', '+xyse);
	
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
		div.style.background = 'url(/images/tiles/'+this.map.id+'/google/'+zoomLevel+'/'+tileCoordinates.x+'/'+tileCoordinates.y+'.png) no-repeat';
		
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
	console.log('maphub.TileOverlay.prototype.latLngToTile: '+latLng);
	var projection = this.map.googleMap.getProjection();
	var worldCoordinate = projection.fromLatLngToPoint(latLng);
	var pixelCoordinate = new google.maps.Point(worldCoordinate.x * Math.pow(2, z), worldCoordinate.y * Math.pow(2, z));
	var tileCoordinate = new google.maps.Point(Math.floor(pixelCoordinate.x / this.tileSize.width), Math.floor(pixelCoordinate.y / this.tileSize.height));
	return tileCoordinate;
}

maphub.TileOverlay.prototype.getTileUrlCoordFromLatLng = function(latlng, zoom) {
	console.log('maphub.TileOverlay.prototype.getTileUrlCoordFromLatLng: '+latlng+', '+zoom);
	return this.getTileUrlCoord(this.latLngToTile(latlng, zoom), zoom)
}

maphub.TileOverlay.prototype.getTileUrlCoord = function(coord, zoom) {
	console.log('maphub.TileOverlay.prototype.getTileUrlCoord: '+coord+', '+zoom);
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