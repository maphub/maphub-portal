/**
 * A ControlPoint is essentially two points in one: an "original" X,Y pair of
 * coordinates, and a resulting latitude,longitude pair of coordinates that
 * were calculated previously.
 * 
 * @author Josh Endries (josh@endries.org)
 * @param x The "original" X coordinate.
 * @param y The "original" Y coordinate.
 * @param latitude The calculated latitude coordinate.
 * @param longitude The calculated longitude coordinate.
 */
maphub.ControlPoint = function(x, y, latitude, longitude) {
	maphub.Point.call(this, x, y);
	this.latitude = latitude;
	this.longitude = longitude;
};



/*
 * Pull in the properties of Points. 
 */
maphub.ControlPoint.inheritFrom(maphub.Point);



/**
 * Retrieve the latitude of this ControlPoint.
 * 
 * @function
 * @public
 * @returns The latitude value.
 */
maphub.ControlPoint.prototype.getLatitude = function() {
	return this.latitude;
};



/**
 * Retrieve the longitude of this ControlPoint.
 * 
 * @function
 * @public
 * @returns The longitude value.
 */
maphub.ControlPoint.prototype.getLongitude = function() {
	return this.longitude;
};



/**
 * Output a pretty representation.
 * 
 * @function
 * @public
 * @returns A string representation of the ControlPoint.
 */
maphub.ControlPoint.prototype.toString = function() {
	return "ControlPoint[x="+this.x+", y="+this.y+", lat="+this.latitude+", long="+this.longitude+"]";
};