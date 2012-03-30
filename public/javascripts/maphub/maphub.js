/*
 * General MapHub namespace: constants and functions.
 */
MapHub = {}; // oops
maphub = {
	RootURL: "/javascripts/maphub"
};



/*
 * MapHub requires jQuery to function.
 */
if (jQuery == "undefined") {
	throw "MapHub requires jQuery to function."; 
}



maphub.load = function() {
	/*
	 * Load the classes. If these change, update the initialization count below.
	 */
	var classes = ["Client", "Map", "Point", "ControlPoint"];
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
					maphub.initialize();
				}
			}
		});
	}
}



/**
 * Augment JavaScript's built-in functions to provide an easy way to inherit
 * from other objects.
 *
 * @author Josh Endries (josh@endries.org)
 * @param parent The parent object from which this object inherits.
 */
Function.prototype.inheritFrom = function(parent) {
    var tmp = function() {};
    tmp.prototype = parent.prototype;
    this.prototype = new tmp();
};



/**
 * Initialize the MapHub interface.
 * 
 * @author Josh Endries (josh@endries.org)
 * @function
 * @static
 */
maphub.initialize = function() {
	/*
	 * Create the MapHub map object.
	 */
	var mapID = 11;
	var map = new maphub.Map(11);

	
	
	/*
	 * Create the Google Maps map.
	 */
	var myOptions = {
		zoom: 8,
		center: new google.maps.LatLng(-34.397, 150.644),
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	document.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	
	var myCopyright = new GCopyrightCollection("� ");
	myCopyright.addCopyright(new GCopyright('Demo', new GLatLngBounds(new GLatLng(-90,-180), new GLatLng(90,180)), 0,'�2007 Google'));
	var tilelayer = new GTileLayer(myCopyright);
	tilelayer.getTileUrl = function() { return map.getTileURL(); };
	tilelayer.isPng = function() { return false; };
	tilelayer.getOpacity = function() { return 1.0; }

	var myTileLayer = new GTileLayerOverlay(tilelayer);
	var map = new GMap2(document.getElementById("map_canvas"));

	
	/*
	 * Get the client's location. The first argument is a success callback and
	 * the second is a failure callback.
	 */
	maphub.Client.getLocation(
		function(coords) { 
			console.log("Client location found:");
			console.log(coords);
		    var latLng = new google.maps.LatLng(coords.latitude, coords.longitude);
		    document.map.setCenter(latLng);
		    document.map.setZoom(12);
		    
		    /*
		     * We have a location, transform it into coordinates.
		     */
			var queryPoints = [ coords.latitude, coords.longitude ];
			var controlPoints = maphub.getControlPoints(11);
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
 * @param {maphub.Point} latitude The coordinates to transform.
 * @param {Array} controlPoints An Array of three objects with x, y, lat and lng properties.
 * @param {Array} queryPoints An Array containing a lat,lng pair in the 0 and 1 indices.
 */
maphub.transform = function(query_points, control_points) {
	if (control_points.length < 3) throw "Insufficient number of control points.";
	
	/*
	 * Extract the query parameters.
	 */
	var queryLat = query_points[0];
	var queryLng = query_points[1];

	/*
	 * Extract the control point parameters.
	 */
    var x1 = control_points[0].x;
    var y1 = control_points[0].y;
    var x2 = control_points[1].x;
    var y2 = control_points[1].y;
    var x3 = control_points[2].x;
    var y3 = control_points[2].y;
    var u1 = control_points[0].lat;
    var v1 = control_points[0].lng;
    var u2 = control_points[1].lat;
    var v2 = control_points[1].lng;
    var u3 = control_points[2].lat;
    var v3 = control_points[2].lng;

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