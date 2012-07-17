var ge;
var overlay_tileset_uri;
google.load("earth", "1");

maphub.EarthView = function(parameters) {
  if (parameters) {
    overlay_tileset_uri = parameters['overlay_tileset_uri'];
    initEarth();
  }
}

//Initializes instance of Google Earth
function initEarth() {
  google.earth.createInstance('map3d', successCB, failureCB);
}

//Success Callback
function successCB(instance) {
  ge = instance;
  ge.getWindow().setVisibility(true);
  // add a navigation control
  ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);
  earthOverlay();
}

//Failure Callback
function failureCB(errorCode) {
}

//Generates a map overlay on top of the Google Earth View
function earthOverlay(){

  var link = ge.createLink('');
  var href = overlay_tileset_uri + '/doc.kml'
  link.setHref(href);

  var networkLink = ge.createNetworkLink('');
  networkLink.set(link, true, true); // Sets the link, refreshVisibility, and flyToView

  ge.getFeatures().appendChild(networkLink);
}
