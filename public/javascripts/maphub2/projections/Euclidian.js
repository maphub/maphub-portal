if (typeof maphub.projections == 'undefined')
	maphub.projections = {};

maphub.projections.Euclidian = function() {
	var EUCLIDEAN_RANGE = 256;
	this.pixelOrigin_ = new google.maps.Point(EUCLIDEAN_RANGE / 2, EUCLIDEAN_RANGE / 2);
	this.pixelsPerLonDegree_ = EUCLIDEAN_RANGE / 360;
	this.pixelsPerLonRadian_ = EUCLIDEAN_RANGE / (2 * Math.PI);
	this.scaleLat = 2;	// Height
	this.scaleLng = 1;	// Width
	this.offsetLat = 0;	// Height
	this.offsetLng = 0;	// Width
	this.ll = document.getElementById('ll');
	this.xy = document.getElementById('xy');
};

maphub.projections.Euclidian.prototype.fromLatLngToPoint = function(latLng, opt_point) {
	this.ll.innerHTML = latLng;
	//var me = this;
	
	var point = opt_point || new google.maps.Point(0, 0);
	
	var origin = this.pixelOrigin_;
	point.x = (origin.x + (latLng.lng() + this.offsetLng ) * this.scaleLng * this.pixelsPerLonDegree_);
	// NOTE(appleton): Truncating to 0.9999 effectively limits latitude to
	// 89.189.  This is about a third of a tile past the edge of the world tile.
	point.y = (origin.y + (-1 * latLng.lat() + this.offsetLat ) * this.scaleLat * this.pixelsPerLonDegree_);
	return point;
};

maphub.projections.Euclidian.prototype.fromPointToLatLng = function(point) {
	this.xy.innerHTML = point;
	var me = this;
	
	var origin = me.pixelOrigin_;
	var lng = (((point.x - origin.x) / me.pixelsPerLonDegree_) / this.scaleLng) - this.offsetLng;
	var lat = ((-1 *( point.y - origin.y) / me.pixelsPerLonDegree_) / this.scaleLat) - this.offsetLat;
	return new google.maps.LatLng(lat , lng, true);
};
