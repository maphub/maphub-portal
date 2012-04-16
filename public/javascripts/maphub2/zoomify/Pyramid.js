if (typeof maphub.zoomify == 'undefined') maphub.zoomify = {};

/**
 * Implements a Zoomify tile set. Based on:
 */
maphub.zoomify.Pyramid = function(width, height) {
	this.width = width;
	this.height = height;
	this.tileSize = 256;
	this.levels = [];

	/*
	 * Since Javascript doesn't have log2(n), we need to construct the entire pyramid from the
	 * bottom up, and then reverse it so the indices are ordered in the usual manner. 
	 */
	var tmpLevels = [];
	id=0;
	var currentLevel = new maphub.zoomify.Level(id, width, height);
	while (currentLevel.width > this.tileSize || currentLevel.height > this.tileSize) {
		id++;
		tmpLevels[tmpLevels.length] = currentLevel;
		currentLevel = new maphub.zoomify.Level(id, Math.floor(currentLevel.width/2), Math.floor(currentLevel.height/2));
	}
	tmpLevels[tmpLevels.length] = currentLevel;
	var i=0;
	for (var k=tmpLevels.length-1; k>=0; k--) {
		tmpLevels[k].id = (tmpLevels.length-1) - k;
		this.levels[i] = tmpLevels[k];
		i++;
	}
	for (var i=0; i<this.levels.length; i++) console.log(this.levels[i]);
};



/**
 * Retrieve the {maphub.zoomify.Level} object for the specified zoom level.
 * 
 * @param zoom The index for the zoom level that will be returned (starting at zero).
 * @returns The {maphub.zoomify.Level} object for the given zoom level.
 */
maphub.zoomify.Pyramid.prototype.getLevel = function(zoom) {
	return this.levels[zoom];
};



/**
 * Retrieve the number of the tile specified by the given zoom level and coordinates. The
 * order is like this:
 * 
 * +-----+-----+-----+
 * | 0,0 | 1,0 | 2,0 |
 * | 0,1 | 1,1 | 2,1 |
 * | 0,2 | 1,2 | 2,2 |
 * +-----+-----+-----+
 * 
 * The file name consists of [zoom]-[x]-[y].jpg, which is misleading. A directory listing will sort
 * the files first based on the zoom level, then the X coordinate, then the Y coordinate. However,
 * processing proceeds first based on the Y coordinate, then the X coordinate, so it will appear as
 * if there are "gaps" in the continuity of the numbering if you look at the file names. In other
 * words, this is what "really" happens:
 * 
 * Directory 1:
 *  4-6.jpg
 *  5-6.jpg
 *  6-6.jpg
 * 
 * Directory 2:
 *  7-6.jpg
 *  1-7.jpg
 *  2-7.jpg
 * 
 * But this is what is looks like when sorted normally:
 * 
 * Directory 1:
 *  4-6.jpg
 *  5-6.jpg
 *  6-6.jpg
 * 
 * Directory 2:
 *  1-7.jpg
 *  2-7.jpg
 *  7-6.jpg
 * 
 * This gets even more complicated when you take into consideration the files use "1" instead of
 * "01", so files greater than ten seem even more out of order. Ultimately, one cannot rely on the
 * order on disk to gauge where the endpoints are in a tile group (which tiles are in each group).
 * One must instead look through the files using the order in which they are processed to find the
 * starting and ending tiles in that group.
 * 
 * @param l The level index (starting from 0).
 * @param x The x coordinate index (starting from 0).
 * @param y The y coordinate index (starting from 0).
 */
maphub.zoomify.Pyramid.prototype.getTileNumber = function(l, x, y) {
	/*
	 * Get the number of tiles up to (but not including) this level.
	 */
	var tileCount = this.numTilesTo(l);

	/*
	 * Count the tiles in this level until we hit our target.
	 */
	var level = this.levels[l];
	for (var row = 0; row < level.yTiles; row++) {
		for (var col = 0; col < level.xTiles; col++) {
			tileCount++;
			if (row == y && col == x) {
				return tileCount;
			}
		}
	}
};



/**
 * Retrieve the tile group in which the specified tile exists.
 */
maphub.zoomify.Pyramid.prototype.getTileGroup = function(level, x, y) {
	var tileNumber = this.getTileNumber(level, x, y);
	return Math.floor((tileNumber-1) / 256);
};



/**
 * Get the number of tiles up to the specified level (exclusive).
 * 
 * @function
 * @param level The level up to which the tiles are counted.
 * @public
 * @returns The number of tiles as an integer.
 */
maphub.zoomify.Pyramid.prototype.numTilesTo = function(level) {
	var sum = 0;
	for (var i=0; i<level; i++) {
		sum += this.levels[i].numTiles();
	}
	return sum;
};



/**
 * Retrieve the number of zoom levels in this tile set.
 */
maphub.zoomify.Pyramid.prototype.numLevels = function() {
	return this.levels.length;
};



/**
 * Retrieve the number of tiles in this tile set.
 */
maphub.zoomify.Pyramid.prototype.numTiles = function() {
	return this.numTilesTo(this.levels.length);
};
