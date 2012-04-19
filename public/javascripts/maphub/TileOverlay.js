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
		
		var self = this;
		google.maps.event.addListener(this.map.googleMap, 'idle', function () {
			self.deleteHiddenTiles();
		});
	}
}

maphub.TileOverlay.prototype.deleteHiddenTiles = function() {
	console.log("Deleting hidden tiles.");
	var bounds = this.map.googleMap.getBounds();
	var zoom = this.map.googleMap.getZoom();
	var ne = bounds.getNorthEast();
	var sw = bounds.getSouthWest();
	var neTile = this.latLngToTile(ne, zoom);
	var swTile = this.latLngToTile(sw, zoom);
	var nwTile = new google.maps.Point(swTile.x, neTile.y);
	var seTile = new google.maps.Point(neTile.x, swTile.y);
	console.log("New tiles: "+neTile+","+swTile+","+nwTile+","+seTile);
	
	var tileNE = this.getTileUrlCoordFromLatLng(bounds.getNorthEast(), zoom);
	var tileSW = this.getTileUrlCoordFromLatLng(bounds.getSouthWest(), zoom);
//	var minX = tileSW.x - 1;
//	var maxX = tileNE.x + 1;
//	var minY = tileSW.y - 1;
//	var maxY = tileNE.y + 1;
	var minX = tileSW.x;
	var maxX = tileNE.x;
	var minY = tileSW.y;
	var maxY = tileNE.y;
	
	
	console.log('Should be (14,10) to (21,12)');
	console.log('('+minX+','+minY+') to ('+maxX+','+maxY+')');

	/*
	 * Create an object in which we will store the tiles we want to keep. This will eventually
	 * be assigned to this.tiles.
	 */
	var tilesToKeep = {};
	console.log("Before: "+Object.keys(this.tiles));
	
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
					console.log(tileID+" matches");
					/*
					 * This tile is visible, keep it.
					 */
					tilesToKeep[tileID] = this.tiles[tileID];
				}
			}
		}
	}
	
	this.tiles = tilesToKeep;
	console.log("After: "+Object.keys(this.tiles));
	return;
	
	for (var i = 0; i < tilesLength; i++) {
		var idParts = this.tiles[i].id.split("_");
		var tileX = Number(idParts[1]);
		var tileY = Number(idParts[2]);
		var tileZ = Number(idParts[3]);
		if ((
				(minX < maxX && (tileX >= minX && tileX <= maxX))
				|| (minX > maxX && ((tileX >= minX && tileX <= (Math.pow(2, zoom) - 1)) || (tileX >= 0 && tileX <= maxX))) // Lapped the earth!
			)
			&& (tileY >= minY && tileY <= maxY)
			&& tileZ == zoom) {
			tilesToKeep.push(this.tiles[i]);
		}
		else {
			delete this.tiles[i];
		}
	}
	
	this.tiles = tilesToKeep;
}

maphub.TileOverlay.prototype.getTile = function(point, zoomLevel, container) {
//	console.log("maphub.TileOverlay.prototype.getTile");

	var xynw = new google.maps.Point(point.x*this.tileSize.width, point.y*this.tileSize.height);
	var xyse = new google.maps.Point((point.x+1)*this.tileSize.width, (point.y+1)*this.tileSize.height);
	
//	console.log("Coord for "+point+': '+xynw+', '+xyse);
	
	/*
	 * If the tile already exists, use it.
	 */
	var tileID = zoomLevel + '-' + point.x + '-' + point.y;
	var div = null;
	if (typeof this.tiles[tileID] == "undefined") {
		/*
		 * The tile doesn't exist, create it.
		 */
//		console.log("Creating new tile for " + tileID);
		div = container.createElement('div');
		div.style.width = this.tileSize.width + 'px';
		div.style.height = this.tileSize.height + 'px';

//		var ymax = 1 << zoomLevel;
//		var y = ymax - point.y - 1;
//		div.style.background = 'url(/images/tiles/ct002033/google/'+zoomLevel+'/'+point.x+'/'+y+'.png) no-repeat';
		var tileCoordinates = this.getTileUrlCoord(point, zoomLevel);
		div.style.background = 'url(/images/tiles/'+this.map.id+'/google/'+zoomLevel+'/'+tileCoordinates.x+'/'+tileCoordinates.y+'.png) no-repeat';

		div.style.border = '1px solid #888';
		div.innerHTML = '('+point.x+','+point.y+')';
		
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
	var projection = this.map.googleMap.getProjection();
	var worldCoordinate = projection.fromLatLngToPoint(latLng);
	var pixelCoordinate = new google.maps.Point(worldCoordinate.x * Math.pow(2, z), worldCoordinate.y * Math.pow(2, z));
	var tileCoordinate = new google.maps.Point(Math.floor(pixelCoordinate.x / this.tileSize.width), Math.floor(pixelCoordinate.y / this.tileSize.height));
	console.log("lLTT: "+worldCoordinate+" "+pixelCoordinate+" "+tileCoordinate);
	return tileCoordinate;
}


maphub.TileOverlay.prototype.getTileUrlCoordFromLatLng = function (latlng, zoom) {
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