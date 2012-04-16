if (typeof maphub.zoomify == 'undefined') maphub.zoomify = {};

/**
 * Represents a single level in a Zoomify map hierarchy.
 */
maphub.zoomify.Level = function(id, width, height) {
	this.id = id;
	this.width = parseInt(width);
	this.height = parseInt(height);
	this.tileSize = 256;
	this.xTiles = Math.ceil(width/this.tileSize);
	this.yTiles = Math.ceil(height/this.tileSize);
};

/**
 * Retrieve the number of tiles in this zoom level.
 */
maphub.zoomify.Level.prototype.numTiles = function() {
	return this.xTiles * this.yTiles;
};

maphub.zoomify.Level.prototype.toString = function() {
	return 'Level<id='+this.id+', WxH='+this.width+'x'+this.height+', XxY='+this.xTiles+'x'+this.yTiles+'>';
};
