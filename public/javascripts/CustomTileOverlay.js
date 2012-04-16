/*******************************************************************************
Copyright (c) 2010-2012. Gavin Harriss
Site: http://www.gavinharriss.com/
Originally developed for: http://www.topomap.co.nz/

Licences: Creative Commons Attribution 3.0 New Zealand License
http://creativecommons.org/licenses/by/3.0/nz/
******************************************************************************/

CustomTileOverlay = function (map, opacity) {
	this.tileSize = new google.maps.Size(256, 256); // Change to tile size being used

	this.map = map;
	this.opacity = opacity;
	this.tiles = [];
	
	this.visible = false;
	this.initialized = false;

	this.self = this;
}

CustomTileOverlay.prototype = new google.maps.OverlayView();

CustomTileOverlay.prototype.getTile = function (p, z, ownerDocument) {
	// If tile already exists then use it
	for (var n = 0; n < this.tiles.length; n++) {
		if (this.tiles[n].id == 't_' + p.x + '_' + p.y + '_' + z) {
			return this.tiles[n];
		}
	}

	// If tile doesn't exist then create it
	var tile = ownerDocument.createElement('div');
	var tp = this.getTileUrlCoord(p, z);
	tile.id = 't_' + tp.x + '_' + tp.y + '_' + z
	tile.style.width = this.tileSize.width + 'px';
	tile.style.height = this.tileSize.height + 'px';
	tile.style.backgroundImage = 'url(' + this.getTileUrl(tp, z) + ')';
	tile.style.backgroundRepeat = 'no-repeat';

	if (!this.visible) {
		tile.style.display = 'none';
	}

	this.tiles.push(tile)

	this.setObjectOpacity(tile);

	return tile;
}

// Save memory / speed up the display by deleting tiles out of view
// Essential for use on iOS devices such as iPhone and iPod!
CustomTileOverlay.prototype.deleteHiddenTiles = function (zoom) {
	var bounds = this.map.getBounds();
	var tileNE = this.getTileUrlCoordFromLatLng(bounds.getNorthEast(), zoom);
	var tileSW = this.getTileUrlCoordFromLatLng(bounds.getSouthWest(), zoom);

	var minX = tileSW.x - 1;
	var maxX = tileNE.x + 1;
	var minY = tileSW.y - 1;
	var maxY = tileNE.y + 1;

	var tilesToKeep = [];
	var tilesLength = this.tiles.length;
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
};

CustomTileOverlay.prototype.pointToTile = function (point, z) {
	var projection = this.map.getProjection();
	var worldCoordinate = projection.fromLatLngToPoint(point);
	var pixelCoordinate = new google.maps.Point(worldCoordinate.x * Math.pow(2, z), worldCoordinate.y * Math.pow(2, z));
	var tileCoordinate = new google.maps.Point(Math.floor(pixelCoordinate.x / this.tileSize.width), Math.floor(pixelCoordinate.y / this.tileSize.height));
	return tileCoordinate;
}

CustomTileOverlay.prototype.getTileUrlCoordFromLatLng = function (latlng, zoom) {
	return this.getTileUrlCoord(this.pointToTile(latlng, zoom), zoom)
}

CustomTileOverlay.prototype.getTileUrlCoord = function (coord, zoom) {
	var tileRange = 1 << zoom;
	var y = tileRange - coord.y - 1;
	var x = coord.x;
	if (x < 0 || x >= tileRange) {
		x = (x % tileRange + tileRange) % tileRange;
	}
	return new google.maps.Point(x, y);
}

// Replace with logic for your own tile set
CustomTileOverlay.prototype.getTileUrl = function (coord, zoom) {
	// Restricting tiles to the small tile set we have in the example
	if (zoom == 13 && coord.x >= 8004 && coord.x <= 8006 && coord.y >= 3013 && coord.y <= 3015) {
		return "tiles/" + zoom + "-" + coord.x + "-" + coord.y + ".png";
	}
	else {
		return "tiles/blanktile.png";
	}
}

CustomTileOverlay.prototype.initialize = function () {
	if (this.initialized) {
		return;
	}
	var self = this.self;
	this.map.overlayMapTypes.insertAt(0, self);
	this.initialized = true;
}

CustomTileOverlay.prototype.hide = function () {
	this.visible = false;

	var tileCount = this.tiles.length;
	for (var n = 0; n < tileCount; n++) {
		this.tiles[n].style.display = 'none';
	}
}

CustomTileOverlay.prototype.show = function () {
	this.initialize();
	this.visible = true;
	var tileCount = this.tiles.length;
	for (var n = 0; n < tileCount; n++) {
		this.tiles[n].style.display = '';
	}
}

CustomTileOverlay.prototype.releaseTile = function (tile) {
	tile = null;
}

CustomTileOverlay.prototype.setOpacity = function (op) {
	this.opacity = op;

	var tileCount = this.tiles.length;
	for (var n = 0; n < tileCount; n++) {
		this.setObjectOpacity(this.tiles[n]);
	}
}

CustomTileOverlay.prototype.setObjectOpacity = function (obj) {
	if (this.opacity > 0) {
		if (typeof (obj.style.filter) == 'string') { obj.style.filter = 'alpha(opacity:' + this.opacity + ')'; }
		if (typeof (obj.style.KHTMLOpacity) == 'string') { obj.style.KHTMLOpacity = this.opacity / 100; }
		if (typeof (obj.style.MozOpacity) == 'string') { obj.style.MozOpacity = this.opacity / 100; }
		if (typeof (obj.style.opacity) == 'string') { obj.style.opacity = this.opacity / 100; }
	}
}