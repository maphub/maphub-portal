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
if (typeof jQuery === 'undefined') { throw 'MapHub requires jQuery to function.'; }
if (typeof requirejs === "undefined") { throw 'MapHub requires RequireJS to function.'; }




/**
 * Load everything.
 */
require(['Map'], function() {
	var map = new maphub.Map({
		id: 'ct002033'
	});
	
	map.render(document.getElementById('map_canvas'));
});



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
