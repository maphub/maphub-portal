$(document).ready(function() {
	/*
	 * Load MapHub JavaScript files.
	 */
	$.ajax({
		cache: true,
		url: "/scripts/maphub/maphub.js",
		dataType: "script"
	});

	
	
	/*
	 * Create the Google Maps map.
	 */
	var myOptions = {
		zoom: 8,
		center: new google.maps.LatLng(-34.397, 150.644),
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	document.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	
	
	
	/*
	 * Get the client's location. The first argument is a success callback and
	 * the second is a failure callback.
	 */
	maphub.Client.getLocation(
		function(coords) { 
			console.log("Client location found: "+coords);
		    var latLng = new google.maps.LatLng(coords.latitude, coords.longitude);
		    document.map.setCenter(latLng);
		    document.map.setZoom(12);
		    
		    /*
		     * Add a pin to the client's location. Specifying the map property
		     * causes the marker to appear on that map.
		     */
		    new google.maps.Marker({
			    map: document.map,
			    position: latLng,
			    title: 'Why, there you are!'
		    });
		},
		function(err) {
			console.log("Error while retrieving client location: "+err);
			if (typeof err != "undefined") {
				var msg;
				switch (err.code) {
					case err.UNKNOWN_ERROR:
						msg = "Unable to find your location";
						break;
					case err.PERMISSION_DENINED:
						msg = "Permission denied in finding your location";
						break;
					case err.POSITION_UNAVAILABLE:
						msg = "Your location is currently unknown";
						break;
					case err.BREAK:
						msg = "Attempt to find location took too long";
						break;
					default:
						msg = "Location detection not supported in browser";
				}
				throw new maphub.Client.LocationException(msg);
			}
		}
	);
});