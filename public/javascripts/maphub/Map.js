/**
 * Map represents a map. Go figure.
 * 
 * @param id
 *           The ID of the map that this instance represents.
 */
maphub.Map = function(id) {
   this.bounds = new google.maps.LatLngBounds(new google.maps.LatLng(41.8128911451, 8.73896538004), new google.maps.LatLng(51.4235907642, 27.8177687755));
	this.id = id;
	this.tileSize = new google.maps.Size(256, 256);
	document.map = this;
};

maphub.Map.prototype.getTile = function(coord, zoom, doc) {
	var div = doc.createElement('div');
	div.style.width = this.tileSize.width + 'px';
	div.style.height = this.tileSize.height + 'px';
//	div.innerHTML = coord;
//	div.style.fontSize = '10';
//	div.style.borderStyle = 'solid';
//	div.style.borderWidth = '1px';
//	div.style.borderColor = '#AAAAAA';
	div.style.opacity = '0.7';

	var ymax = 1 << zoom;
   var y = ymax-coord.y-1;
	div.style.background='url(/images/tiles/ct002033/google/'+zoom+'/'+coord.x+'/'+y+'.png) no-repeat';
	
	return div;
};

maphub.Map.prototype.render = function(containerID) {
	console.log("Rendering map to element \""+containerID+"\"");
	var mapOptions = {
		center: new google.maps.LatLng(44.777936,12.026365),
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		streetViewControl: false,
		zoom: 6
	};
	this.googleMap = new google.maps.Map(document.getElementById(containerID), mapOptions);
	google.maps.event.addListener(this.googleMap,'zoom_changed',function(){console.log("Zoom level: "+document.map.googleMap.getZoom());});

	// Insert this overlay map type as the first overlay map type at
	// position 0. Note that all overlay map types appear on top of
	// their parent base map.
	this.googleMap.overlayMapTypes.push(this);
};