/**
 * Map represents a map. Go figure.
 * 
 * @param id The ID of the map that this instance represents.
 */
maphub.Map = function(id) {
	/*
	 * The map identifier.
	 */
	this.id = id;
	
	/*
	 * A jQuery object containing the XML metadata for this map (implemented below).
	 */
	this.xml = {};
	
	/*
	 * This map's control points (implemented below) as an array of ControlPoint objects.
	 */
	this.controlPoints = [];
	
	/**
	 * This map's type identifier. The Google Maps API uses these to differentiate maps in the UI.
	 * 
	 * @constant
	 * @field
	 * @private
	 */
	this.type = "maphub";
	
	/**
	 * This map's tile size. Required by the Google Maps MapType interface.
	 * 
	 * @constant
	 * @field
	 * @public
	 */
	this.tileSize = new google.maps.Size(256, 256);

	/*
	 * Retrieve the map XML metadata from the server.
	 */
	var xml = null;
	$.ajax({
		async: false,
		cache: false,
		dataType: "xml",
		success: function(data, status, xhr) {
			xml = $(data);
		},
		url: "/maps/"+id+".xml"
	});
	this.xml = xml;
	
	/*
	 * Retrieve the control points from the server.
	 */
	var controlPoints = [];
	$.ajax({
		async: false,
		cache: false,
		dataType: "xml",
		success: function(data, status, xhr) {
			$(data).find("control-point").each(function() {
				var lat = $(this).find("lat").text();
				var lng = $(this).find("lng").text();
				var x = $(this).find("x").text();
				var y = $(this).find("y").text();
				var cp = new maphub.ControlPoint(x, y, lat, lng);
				controlPoints.push(cp);
			});
		},
		url: "/maps/"+id+"/control_points.xml"
	});
	this.controlPoints = controlPoints;
	
	/**
	 * The Zoomify-based pyramid representation of this map's tiles.
	 */
	this.tileSet = new maphub.zoomify.Pyramid(this.xml.find("width").text(), this.xml.find("height").text());
	
	/**
	 * This map's maximum zoom level. Required by the Google Maps MapType interface. This uses the
	 * tile set so it must be set after the tile set is instantiated (above).
	 * 
	 * @constant
	 * @field
	 * @public
	 */
	this.maxZoom = this.tileSet.numLevels();
};



/**
 * Retrieve the control points for this map.
 * 
 * @function
 * @public
 */
maphub.Map.prototype.getControlPoints = function() {
	return this.controlPoints;
};



/**
 * Retrieve this map's identifier.
 * 
 * @function
 * @public
 * @returns The identifier for this map.
 */
maphub.Map.prototype.getID = function() {
	return this.id;
};



/**
 * Retrieve a tile for this map. Required by the Google Maps MapType interface.
 * 
 * @param {google.maps.Point} tileCoord the tile coordinates.
 * @param {number} zoom the zoom level.
 * @param {Node} ownerDocument.
 * @returns {Node} the overlay.
 */
maphub.Map.prototype.getTile = function(tileCoord, zoom, ownerDocument) {
	/*
	 * Create a "node" to return. We create a div element with a dark background. If there is no
	 * appropriate tile for these coordinates, this empty div will appear instead.
	 */
	var div = ownerDocument.createElement('div');
	div.style.background = "#eee";
	div.style.width = this.tileSize.width + 'px';
	div.style.height = this.tileSize.height + 'px';
	div.innerHTML = tileCoord;
	div.style.color = '#666';
	div.style.border = '1px solid #666';
	
	/*
	 * We don't do negative coordinates...
	 */
	if (tileCoord.x < 0 || tileCoord.y < 0) return div;

	/*
	 * Get the tile group number from the tile set and construct the URL from which to get this
	 * tile.
	 */
	var tileGroup = "TileGroup" + this.tileSet.getTileGroup(zoom, tileCoord.x, tileCoord.y);
	var url = this.getTileURL() + "/" + tileGroup + "/" + zoom + "-" + tileCoord.x + "-" + tileCoord.y + ".jpg";
	
	/*
	 * Since we have a tile, reset the div's background.
	 */
	div.style.background = "#eee url("+url+") no-repeat";
	
	return div;
};


/**
 * Retrieve this map's tile URL.
 * 
 * @function
 * @public
 * @returns The tile set URL.
 */
maphub.Map.prototype.getTileURL = function() {
	return this.xml.find("tileset-url").text();
};



/**
 * Retrieve this map's type identifier.
 * 
 * @function
 * @public
 * @returns The type identifier.
 */
maphub.Map.prototype.getType = function() {
	return this.type;
};
