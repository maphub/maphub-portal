/**
 * Map represents a map. Go figure.
 * 
 * @param id
 *           The ID of the map that this instance represents.
 */
maphub.Map = function(id) {
	this.tileURLPrefix = "/images/tiles/" + id;

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
	// var xml = null;
	// $.ajax({
	// async: false,
	// cache: false,
	// dataType: "xml",
	// success: function(data, status, xhr) {
	// xml = $(data);
	// },
	// url: "/maps/"+id+".xml"
	// });
	// this.xml = xml;
	/*
	 * Retrieve the control points from the server.
	 */
	// var controlPoints = [];
	// $.ajax({
	// async: false,
	// cache: false,
	// dataType: "xml",
	// success: function(data, status, xhr) {
	// $(data).find("control-point").each(function() {
	// var lat = $(this).find("lat").text();
	// var lng = $(this).find("lng").text();
	// var x = $(this).find("x").text();
	// var y = $(this).find("y").text();
	// var cp = new maphub.ControlPoint(x, y, lat, lng);
	// controlPoints.push(cp);
	// });
	// },
	// url: "/maps/"+id+"/control_points.xml"
	// });
	// this.controlPoints = controlPoints;
	this.opacity = 0.75;
	this.minZoom = 0;
	this.maxZoom = 3;
	this.currentZoom = parseInt(this.maxZoom-((this.maxZoom-this.minZoom)/2));
	this.bounds = new GLatLngBounds(new GLatLng(41.8128911451, 8.73896538004), new GLatLng(51.4235907642, 27.8177687755));
};



maphub.Map.prototype.render = function(containerID) {
   // Bug in the Google Maps: Copyright for Overlay is not correctly displayed
   var gcr = GMapType.prototype.getCopyrights;
   GMapType.prototype.getCopyrights = function(bounds,zoom) {
       return [""].concat(gcr.call(this,bounds,zoom));
   }

   var map = new GMap2( document.getElementById(containerID), { backgroundColor: '#fff' } );
   map.addMapType(G_PHYSICAL_MAP);
   map.setMapType(G_PHYSICAL_MAP);
   map.setCenter(document.map.bounds.getCenter(), document.map.currentZoom); // map.getBoundsZoomLevel( document.map.bounds )

   hybridOverlay = new GTileLayerOverlay( G_HYBRID_MAP.getTileLayers()[1] );
   GEvent.addListener(map, "maptypechanged", function() {
     if (map.getCurrentMapType() == G_HYBRID_MAP) {
         map.addOverlay(hybridOverlay);
     } else {
        map.removeOverlay(hybridOverlay);
     }
   } );

   var tilelayer = new GTileLayer(GCopyrightCollection(''), document.map.minZoom, document.map.maxZoom);
   var mercator = new GMercatorProjection(document.map.maxZoom+1);
   tilelayer.getTileUrl = function(tile,zoom) {
       if ((zoom < document.map.minZoom) || (zoom > document.map.maxZoom)) {
           return "http://www.maptiler.org/img/none.png";
       } 
       var ymax = 1 << zoom;
       var y = ymax - tile.y -1;
       var tileBounds = new GLatLngBounds(
           mercator.fromPixelToLatLng( new GPoint( (tile.x)*256, (tile.y+1)*256 ) , zoom ),
           mercator.fromPixelToLatLng( new GPoint( (tile.x+1)*256, (tile.y)*256 ) , zoom )
       );
       if (document.map.bounds.intersects(tileBounds)) {
           return document.map.tileURLPrefix+"/google/"+zoom+"/"+tile.x+"/"+y+".png";
       } else {
           return "http://www.maptiler.org/img/none.png";
       }
   }
   // IE 7-: support for PNG alpha channel
   // Unfortunately, the opacity for whole overlay is then not changeable, either or...
   tilelayer.isPng = function() { return true;};
   tilelayer.getOpacity = function() { return document.map.opacity; }

   overlay = new GTileLayerOverlay( tilelayer );
   map.addOverlay(overlay);

   map.addControl(new GLargeMapControl());
   map.addControl(new GHierarchicalMapTypeControl());
   map.addControl(new CTransparencyControl( overlay ));


   map.enableContinuousZoom();
   map.enableScrollWheelZoom();

//   map.setMapType(G_HYBRID_MAP);
}



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
 * @param {google.maps.Point}
 *           tileCoord the tile coordinates.
 * @param {number}
 *           zoom the zoom level.
 * @param {Node}
 *           ownerDocument.
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
	if (tileCoord.x < 0 || tileCoord.y < 0)
		return div;

	/*
	 * Get the tile group number from the tile set and construct the URL from which to get this tile.
	 */
	var tileGroup = "TileGroup" + this.tileSet.getTileGroup(zoom, tileCoord.x, tileCoord.y);
	var url = this.getTileURL() + "/" + tileGroup + "/" + zoom + "-" + tileCoord.x + "-"
			+ tileCoord.y + ".jpg";

	/*
	 * Since we have a tile, reset the div's background.
	 */
	div.style.background = "#eee url(" + url + ") no-repeat";

	return div;
};



/**
 * Retrieve this map's tile set.
 */
maphub.Map.prototype.getTileSet = function() {
	return this.tileSet;
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



maphub.Map.prototype.getZoom = function() {
	return this.currentZoom;
}



maphub.Map.prototype.setZoom = function(level) {
	this.currentZoom = level;
};