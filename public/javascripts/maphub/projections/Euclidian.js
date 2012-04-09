/*
 * 
 * This doesn't seem to work, there is no 'b' (zoom level) available to the converion methods
 * 
 * 
 */

if (typeof maphub.projections == 'undefined')
	maphub.projections = {};

maphub.projections.Euclidian = function(map) {
	this.pixelsPerLonDegree = [];
	this.pixelsPerLonRadian = [];
	this.pixelOrigo = [];
	this.tileBounds = [];
	this.map = map;
	var b = 256;
	var c = 1;
	for (var zoomLevel = 0; zoomLevel < map.maxZoom; zoomLevel++) {
		var e = b / 2;
		this.pixelsPerLonDegree.push(b / 360);
		this.pixelsPerLonRadian.push(b / (2 * Math.PI));
		this.pixelOrigo.push(new google.maps.Point(e, e));
		this.tileBounds.push(c);
		b *= 2;
		c *= 2
	}
};

maphub.projections.Euclidian.prototype.fromLatLngToPoint = function(latLng) {
	var b = this.map.getZoom();
	var c = Math.round(this.pixelOrigo[b].x + latLng.lng() * this.pixelsPerLonDegree[b]);
	var d = Math.round(this.pixelOrigo[b].y + (-2 * latLng.lat()) * this.pixelsPerLonDegree[b]);
	console.log("Converted from ("+b+") "+latLng.lat()+"|"+latLng.lng()+" to "+c+","+d);
	return new google.maps.Point(c, d);
};

maphub.projections.Euclidian.prototype.fromPointToLatLng = function(a) {
	var b = this.map.getZoom();
	var d = (a.x - this.pixelOrigo[b].x) / this.pixelsPerLonDegree[b];
	var e = -0.5 * (a.y - this.pixelOrigo[b].y) / this.pixelsPerLonDegree[b];
	console.log("Converted from ("+b+") "+a.x+","+a.y+" to "+e+"|"+d);
	return new google.maps.LatLng(e, d);
};

//maphub.projections.Euclidian.prototype.tileCheckRange = function(a, b, c) {
//	var d = this.tileBounds[b];
//	if (a.y < 0 || a.y >= d) {
//		return false;
//	}
//	if (a.x < 0 || a.x >= d) {
//		a.x = a.x % d;
//		if (a.x < 0) {
//			a.x += d;
//		}
//	}
//	return true
//};
//
//// == a method that returns the width of the tilespace ==
//maphub.projections.Euclidian.prototype.getWrapWidth = function(zoom) {
//	return this.tileBounds[zoom] * 256;
//};