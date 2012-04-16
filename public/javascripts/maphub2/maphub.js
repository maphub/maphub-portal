/*
 * General MapHub namespace: constants and functions.
 */
MapHub = {}; // oops
maphub = {
	RootURL: "/javascripts/maphub2"
};



/*
 * MapHub requires jQuery to function.
 */
if (jQuery == "undefined") {
	throw "MapHub requires jQuery to function."; 
}



maphub.load = function() {
	/*
	 * Load the classes.
	 */
	var classes = ["Client", "Map", "ControlPoint", "CTransparencyControl" ];
	for (var i in classes) {
		console.log("Loading "+maphub.RootURL+"/"+classes[i]+".js");
		$.ajax({
			async: false,
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
 * Initialize the MapHub interface. The following parameters may be specified:
 * 	container: A string containing the ID for the DOM element in which the map will be created.
 * 
 * @function
 * @param params An object containing members for parameters.
 * @static
 */
maphub.initialize = function() {
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