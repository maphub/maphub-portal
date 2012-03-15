/**
 * The Client class represents a viewer of the application.
 * 
 * @author Josh Endries <josh@endries.org>
 */
maphub.Client = function() {};



maphub.Client.locationFailureCallback = function() {
	console.log("WTF");
}



/**
 * getLocation retrieves the client's location, if possible.
 * 
 * @function
 * @param successCallback The function to call when a location is found.
 * @param failureCallback The function to call when a location is not found.
 * @public
 * @returns nsIDOMGeoPositionCoords The coordinates.
 * @static
 * @throws {@link LocationException} if the location was not found.
 */
maphub.Client.getLocation = function(successCallback, failureCallback) {
	/*
	 * The delay, in milliseconds, before calling the timeout function if an
	 * error occurs while retrieving the geographical location.
	 */
	var timeoutDelay = 7000;
	
	/*
	 * Set the timeout timer to null in case we aren't given a failureCallback
	 * of we're given something that isn't a function.
	 */
	var timeoutTimer = null;
	
	/*
	 * Set the failureCallback to null, in case the failureCallback we're
	 * passed doesn't exist or isn't a function. This is actually a "static"
	 * property on the maphub.Client.getLocation "class", so the timeout timer
	 * can access it (timers exist in the global scope). This isn't very
	 * elegant, but works.
	 * 
	 * TODO: Re-factor this to something nicer.
	 */
	maphub.Client.locationFailureCallback = null;

	/*
	 * If we're given a valid failureCallback function, set the "static" method
	 * to it so the timer can access it and start the timeout timer. This timer
	 * will fire if there is an error retrieving the geographical location or
	 * if nothing happens (e.g. if the user dismisses the dialog instead of
	 * clicking "no").
	 */
	if (typeof failureCallback == "function") {
		maphub.Client.locationFailureCallback = failureCallback;
		console.log(maphub.Client.locationFailureCallback);
		timeoutTimer = setTimeout("maphub.Client.locationFailureCallback()", timeoutDelay);
	}
	
	/*
	 * The success function is called when we receive a set of coordinates that
	 * (hopefully) represent the client's geographical location. This function
	 * also clears the failure timer and calls the successCallback that we are
	 * passed, if it's a valid function.
	 */
	var success = function(position) {
		if (typeof failureCallback == "function") {
			clearTimeout(timeoutTimer);
		}
		
		var coords = position.coords || position.coordinate || position;
		if (typeof successCallback == "function") {
			successCallback(coords);
		}
	};

	/*
	 * Attempt to retrieve the client's geographical location.
	 */
	navigator.geolocation.getCurrentPosition(success, maphub.Client.getLocation.failureCallback, {enableHighAccuracy: true, timeout: timeoutDelay});
};
