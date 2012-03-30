/**
 * Map represents a map.
 * 
 * @author Josh Endries (josh@endries.org)
 * @param id The ID of the map that this instance represents.
 */
maphub.Map = function(id) {
	/*
	 * The map identifier.
	 */
	this.id = id;
	
	/*
	 * A jQuery object containing the XML metadata for this map (implemented below).
	 */
	this.xml = {};
	
	/*
	 * This map's control points (implemented below) as an array of ControlPoint objects.
	 */
	this.controlPoints = [];

	/*
	 * Retrieve the map XML metadata from the server.
	 */
	var xml = null;
	$.ajax({
		async: false,
		cache: false,
		dataType: "xml",
		success: function(data, status, xhr) {
			xml = $(data);
		},
		url: "/maps/"+id+".xml"
	});
	this.xml = xml;
	
	/*
	 * Retrieve the control points from the server.
	 */
	var controlPoints = [];
	$.ajax({
		async: false,
		cache: false,
		dataType: "xml",
		success: function(data, status, xhr) {
			$(data).find("control-point").each(function() {
				var lat = $(this).find("lat").text();
				var lng = $(this).find("lng").text();
				var x = $(this).find("x").text();
				var y = $(this).find("y").text();
				var cp = new maphub.ControlPoint(x, y, lat, lng);
				controlPoints[controlPoints.length] = cp;
			});
		},
		url: "/maps/"+id+"/control_points.xml"
	});
	this.controlPoints = controlPoints;
};



/**
 * Retrieve this map's identifier.
 * 
 * @function
 * @public
 * @return The identifier for this map.
 */
maphub.Map.prototype.getID = function() {
	return this.id;
};



/**
 * Retrieve the control points for this map.
 * 
 * @function
 * @public
 */
maphub.Map.prototype.getControlPoints = function() {
	/*
	 * Retrieve the control points from the Rails server.
	 */
	var controlPoints = [];
	$.ajax({
		async: false,
		cache: false,
		dataType: "xml",
		success: function(data, status, xhr) {
			$(data).find("control-point").each(function() {
				var controlPoint = {
					lat: $(this).find("lat").text(),
					lng: $(this).find("lng").text(),
					x: $(this).find("x").text(),
					y: $(this).find("y").text(),
				};
				controlPoints[controlPoints.length] = controlPoint;
			});
		},
		url: "/maps/"+id+"/control_points.xml"
	});
	console.log(controlPoints);
	
	return controlPoints;
};



/**
 * Retrieve this map's tile URL.
 */
maphub.Map.prototype.getTileURL = function() {
	return this.xml.find("tileset-url").text();
}