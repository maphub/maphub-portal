/*
 * Declare AlphaOverlay as a dependency since that is the actual map overlay that is used.
 */
define(['AlphaOverlay'], function() {
	/**
	 * Map represents a map. Go figure.
	 * 
	 * @param id
	 *           The ID of the map that this instance represents.
	 */
	maphub.Map = function(parameters) {
		if (parameters) {
			this.id = parameters.id;
		}
	   this.bounds = new google.maps.LatLngBounds(new google.maps.LatLng(41.8128911451, 8.73896538004), new google.maps.LatLng(51.4235907642, 27.8177687755));
		document.map = this;
	};

	maphub.Map.prototype.render = function(container) {
		var mapOptions = {
				center: this.bounds.getCenter(),
				mapTypeId: google.maps.MapTypeId.ROADMAP,
				streetViewControl: false,
				zoom: 5
			};
		this.googleMap = new google.maps.Map(container, mapOptions);
		
		var overlay = new maphub.AlphaOverlay({
			map: this,
			tileSize: new google.maps.Size(256,256);
		})
		
		//new google.maps.Marker({ map: document.map, position: new google.maps.LatLng(-45,180), title: '-45,180' });
		
		google.maps.event.addListener(this.googleMap,'zoom_changed',function(){console.log("Zoom level: "+document.map.googleMap.getZoom());});

		// Insert this overlay map type as the first overlay map type at
		// position 0. Note that all overlay map types appear on top of
		// their parent base map.
		this.googleMap.overlayMapTypes.push(overlay);
	};

	maphub.Map.toString = function() {
		return 'Map<id='+this.id+'>';
	}
});
