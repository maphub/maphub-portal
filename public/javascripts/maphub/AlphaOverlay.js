maphub.AlphaOverlay = function(parameters) {
	if (parameters) {
		maphub.TileOverlay.prototype.constructor.apply(this, [parameters]);
		this.tile = parameters;
	}
};

maphub.AlphaOverlay.prototype = new maphub.TileOverlay();
