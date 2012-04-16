/*
 * General MapHub namespace: constants and functions.
 */
MapHub = {}; // oops
maphub = {
	RootURL: "/javascripts/maphub"
};



/*
 * Verify that our required libraries are loaded.
 */
if (jQuery == 'undefined') { throw 'MapHub requires jQuery to function.'; }
if (requirejs == "undefined") { throw 'MapHub requires RequireJS to function.'; }




/**
 * Load everything.
 */
require(['Map']);


maphub.load = function(callback) {
	/*
	 * Load the classes.
	 */
	var classes = ["Client", "Map", "ControlPoint", "TileOverlay", "AlphaOverlay"];
	for (var i in classes) {
		console.log("Loading "+maphub.RootURL+"/"+classes[i]+".js");
		$.ajax({
			cache: true,
			url: maphub.RootURL+"/"+classes[i]+".js",
			dataType: "script",
			complete: function(data, status, xhr) {
				if (window.tmpLoadCount) {
					window.tmpLoadCount++;
				} else {
					window.tmpLoadCount = 1;
				}
				
				if (window.tmpLoadCount == classes.length) {
					console.log("Initializing...");
//					maphub.initialize();
					callback();
				}
			}
		});
	}
};



///////////////////////////////////////////////////////////////////////////////
function EuclideanProjection() {
	var EUCLIDEAN_RANGE = 256;
	this.pixelOrigin_ = new google.maps.Point(EUCLIDEAN_RANGE / 2, EUCLIDEAN_RANGE / 2);
	this.pixelsPerLonDegree_ = EUCLIDEAN_RANGE / 360;
	this.pixelsPerLonRadian_ = EUCLIDEAN_RANGE / (2 * Math.PI);
	this.scaleLat = 2;	// Height
	this.scaleLng = 1;	// Width
	this.offsetLat = 0;	// Height
	this.offsetLng = 0;	// Width
};
EuclideanProjection.prototype.fromLatLngToPoint = function(latLng, opt_point) {
	//var me = this;
	
	var point = opt_point || new google.maps.Point(0, 0);
	
	var origin = this.pixelOrigin_;
	point.x = (origin.x + (latLng.lng() + this.offsetLng ) * this.scaleLng * this.pixelsPerLonDegree_);
	// NOTE(appleton): Truncating to 0.9999 effectively limits latitude to
	// 89.189.  This is about a third of a tile past the edge of the world tile.
	point.y = (origin.y + (-1 * latLng.lat() + this.offsetLat ) * this.scaleLat * this.pixelsPerLonDegree_);
	return point;
};
 
EuclideanProjection.prototype.fromPointToLatLng = function(point) {
	var me = this;
	
	var origin = me.pixelOrigin_;
	var lng = (((point.x - origin.x) / me.pixelsPerLonDegree_) / this.scaleLng) - this.offsetLng;
	var lat = ((-1 *( point.y - origin.y) / me.pixelsPerLonDegree_) / this.scaleLat) - this.offsetLat;
	return new google.maps.LatLng(lat , lng, true);
};
///////////////////////////////////////////////////////////////////////////////



/**
 * Initialize the MapHub interface.
 * 
 * @function
 * @static
 */
maphub.initialize = function() {
	/*
	 * Create the MapHub map object.
	 */
	var mapID = 11;
	var map = new maphub.Map(11);
	map.projection = new maphub.projections.Euclidian(map);
	document.mapHubMap = map; // Fix this.
	var zoomLevel = map.getZoom();
	
	
	/*
	 * Create the Google Maps map.
	 */
	var myOptions = {
		center: new google.maps.LatLng(0, 0),
		zoom: zoomLevel,
		mapTypeControlOptions: {
		     mapTypeIds: [ map.getType() ]
		},
		mapTypeId: map.getType(),
		minZoom: zoomLevel,
	};
	
	
	document.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	document.map.mapTypes.set(map.getType(), map);
	
	
	
	/*
	 * Intercept map panning. The constructors here are LatLngBounds(sw,ne) and LatLng(lat,lng).
	 * We first create a rectangle (specified in lat/lng) in which the user is allowed to pan the
	 * map around. Any movement that would pan outside of this rectangle is not allowed. Then we
	 * create an event listener for when the user pans the map. If the center of the map is not
	 * within the allowed rectangle, the map is forced to the last known valid position, making it
	 * appear as it the map cannot be moved any more.
	 * 
	 * A rectangle of (-84.7,-180; 84.7,180) prevents panning more than one tile from the map edge.
	 */
	var xTiles = map.getTileSet().getLevel(document.map.getZoom()).xTiles;
	var longDegPerTile = xTiles / 90;
	document.map.allowedBounds = new google.maps.LatLngBounds(
			new google.maps.LatLng(-84.7, (-90 - longDegPerTile), true),
			new google.maps.LatLng(84.7, (90 + longDegPerTile), true)
	);
//	document.map.lastValidCenter = document.map.getCenter();
	
	/*
	 * Attempting to fix the zoomed-in boundaries...
	 */
	google.maps.event.addListener(document.map, 'zoom_changed', function() {
//		var xTiles = document.mapHubMap.getTileSet().getLevel(document.map.getZoom()).xTiles;
//		var longDegPerTile = 90/xTiles;
//		console.log(longDegPerTile);
//		document.map.allowedBounds = new google.maps.LatLngBounds(
//				new google.maps.LatLng(-84.7, (-90 - longDegPerTile), true),
//				new google.maps.LatLng(84.7, (90 + longDegPerTile), true)
//		);
		map.setZoom(document.map.getZoom());
	});
//	google.maps.event.addListener(document.map, 'center_changed', function() {
//		var c = document.map.getCenter();
//		if (document.map.allowedBounds.contains(c)) {
//			document.map.lastValidCenter = c;
//		} else {
//			document.map.panTo(document.map.lastValidCenter);
//		}
//	});
	
	
	
	/*
	 * Add "border" pins.
	 */
	new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(0,0), title: '0,0' });
	new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(0,180), title: '0,180' });
	new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(45,0), title: '45,0' });
	new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(45,180), title: '45,180' });
	new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(-45,0), title: '-45,0' });
   new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(-45,180), title: '-45,180' });

   
	
	/*
	 * Get the client's location. The first argument is a success callback and
	 * the second is a failure callback.
	 */
	maphub.Client.getLocation(
		function(coords) { 
			console.log("Client location found:");
			console.log(coords);
		    var latLng = new google.maps.LatLng(coords.latitude, coords.longitude);
//		    document.map.setCenter(latLng);
//		    document.map.setZoom(12);
		    
		    /*
		     * We have a location, transform it into coordinates.
		     */
			var queryPoints = [ coords.latitude, coords.longitude ];
			var controlPoints = map.getControlPoints();
			console.log("Control Points:");
			console.log(controlPoints);
			var result = maphub.transform(queryPoints, controlPoints);
			console.log("Transformed X,Y:");
			console.log(result);
		    
		    /*
		     * Add a pin to the client's location. Specifying the map property
		     * causes the marker to appear on that map.
		     */
		    new google.maps.Marker({
			    map: document.map,
			    position: latLng,
			    title: 'Why, there you are!'
		    });
		},
		function(err) {
			console.log("Error while retrieving client location: "+err);
			if (typeof err != "undefined") {
				var msg;
				switch (err.code) {
					case err.UNKNOWN_ERROR:
						msg = "Unable to find your location";
						break;
					case err.PERMISSION_DENINED:
						msg = "Permission denied in finding your location";
						break;
					case err.POSITION_UNAVAILABLE:
						msg = "Your location is currently unknown";
						break;
					case err.BREAK:
						msg = "Attempt to find location took too long";
						break;
					default:
						msg = "Location detection not supported in browser";
				}
				throw new maphub.Client.LocationException(msg);
			}
		}
	);
};



/**
 * Transform the given latitude and longitude into x,y coordinates appropriate
 * to the map represented by the given control points.
 * 
 * @param query_points An {Array} containing a lat,lng pair in the 0 and 1 indices.
 * @param controlPoints An {Array} of three or more {maphub.ControlPoint} objects.
 */
maphub.transform = function(query_points, controlPoints) {
	if (controlPoints.length < 3) throw "Insufficient number of control points.";
	
	console.log(controlPoints[0]);
	
	/*
	 * Extract the query parameters.
	 */
	var queryLat = query_points[0];
	var queryLng = query_points[1];

	/*
	 * Extract the control point parameters.
	 */
    var x1 = controlPoints[0].getX();
    var y1 = controlPoints[0].getY();
    var x2 = controlPoints[1].getX();
    var y2 = controlPoints[1].getY();
    var x3 = controlPoints[2].getX();
    var y3 = controlPoints[2].getY();
    var u1 = controlPoints[0].getLatitude();
    var v1 = controlPoints[0].getLongitude();
    var u2 = controlPoints[1].getLatitude();
    var v2 = controlPoints[1].getLongitude();
    var u3 = controlPoints[2].getLatitude();
    var v3 = controlPoints[2].getLongitude();

    /*
     * Compute the matrix coefficients.
     */
    var a = (x2 * (v3 - v1) - x3 * (v2 - v1) - x1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    var b = (x2 * (u3 - u1) - x3 * (u2 - u1) - x1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    var c = x1 - a * u1 - b * v1;
    var d = (y2 * (v3 - v1) - y3 * (v2 - v1) - y1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    var e = (y2 * (u3 - u1) - y3 * (u2 - u1) - y1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    var f = y1 - d * u1 - e * v1;

    /*
     * Compute the transform.
     */
    var x = a * queryLat + b * queryLng + c;
    var y = d * queryLat + e * queryLng + f;

    return [x, y];
};
