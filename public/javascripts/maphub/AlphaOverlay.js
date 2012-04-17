define(['TileOverlay'], function() { 
	maphub.AlphaOverlay = function(parameters) {
		if (parameters) {
			maphub.TileOverlay.prototype.constructor.apply(this, [parameters]);
		}
	};

	maphub.AlphaOverlay.prototype = new maphub.TileOverlay();
	maphub.AlphaOverlay.constructor = maphub.AlphaOverlay;

	maphub.AlphaOverlay.prototype.getTile = function(point, zoomLevel, container) {
		console.log("maphub.AlphaOverlay.prototype.getTile");
		var tile = maphub.TileOverlay.prototype.getTile.apply(this, [point, zoomLevel, container]);
		return tile;
	}

	console.log('AO loaded.');
});
