/**
 * The Point class implements a simple set of X,Y coordinates.
 * 
 * @author Josh Endries (josh@endries.org)
 * @param x The X coordinate.
 * @param y The Y coordinate.
 */
maphub.Point = function(x, y) {
	this.x = x;
	this.y = y;
};



/**
 * Retrieve the X coordinate of this point.
 * 
 * @function
 * @public
 * @returns The X coordinate value.
 */
maphub.Point.prototype.getX = function() {
	return this.x;
};



/**
 * Retrieve the Y coordinate of this point.
 * 
 * @function
 * @public
 * @returns The Y coordinate value.
 */
maphub.Point.prototype.getY = function() {
	return this.y;
};



/**
 * Retrieve a pretty representation of this Point.
 * 
 * @function
 * @public
 * @returns A string representation of this Point.
 */
maphub.Point.prototype.toString = function() {
	return "Point[x="+this.x+", y="+this.y+"]";
};