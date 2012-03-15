/*
 * General MapHub namespace: constants and functions.
 */
maphub = {
	ROOT_URL: "/scripts/maphub"
};



/*
 * MapHub requires jQuery to function.
 */
if (jQuery == "undefined") {
	throw "MapHub requires jQuery to function."; 
}



/*
 * Load the classes.
 */
var classes = ["Client", "Point", "ControlPoint"];
for (var i in classes) {
	$.ajax({
		cache: true,
		url: maphub.ROOT_URL+"/"+classes[i]+".js",
		dataType: "script"
	});
}



/**
 * Augment JavaScript's built-in functions to provide an easy way to inherit
 * from other objects.
 *
 * @author Josh Endries <josh@endries.org>
 * @param parent The parent object from which this object inherits.
 */
Function.prototype.inheritFrom = function(parent) {
    var tmp = function() {};
    tmp.prototype = parent.prototype;
    this.prototype = new tmp();
};



/**
 * Transform the given latitude and longitude into x,y coordinates appropriate
 * to the map represented by the given control points.
 * 
 * @param {maphub.Point} latitude The coordinates to transform.
 * @param {Array} controlPoints An Array of three {maphub.ControlPoint} objects.
 */
maphub.transform = function(queryPoints, controlPoints) {
/*
	 def self.compute_XY_from_known_latlng(lat, lng, control_points)
	    raise ArgumentError if control_points.length != 3
	    
	    # Compute matrix coefficients
	    x1 = control_points[0].x;
	    y1 = control_points[0].y;
	    x2 = control_points[1].x;
	    y2 = control_points[1].y;
	    x3 = control_points[2].x;
	    y3 = control_points[2].y;

	    u1 = control_points[0].lat;
	    v1 = control_points[0].lng;
	    u2 = control_points[1].lat;
	    v2 = control_points[1].lng;
	    u3 = control_points[2].lat;
	    v3 = control_points[2].lng;

	    a = (x2 * (v3 - v1) - x3 * (v2 - v1) - x1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
	    b = (x2 * (u3 - u1) - x3 * (u2 - u1) - x1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
	    c = x1 - a * u1 - b * v1;

	    d = (y2 * (v3 - v1) - y3 * (v2 - v1) - y1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
	    e = (y2 * (u3 - u1) - y3 * (u2 - u1) - y1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
	    f = y1 - d * u1 - e * v1;

	    # Compute transform
	    x = a * lat + b * lng + c;
	    y = d * lat + e * lng + f;

	    return x, y
	  end
*/
};