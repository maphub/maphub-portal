/**
 * Loosely based on Gavin Harriss' maphub.TileOverlay (http://www.gavinharriss.com/)
 */
maphub.TileOverlay = function(parameters) {
	this.tiles = {};
	if (parameters) {
		this.tileSize = parameters.tileSize;
	}
};
