maphub.EarthView = function(parameters) {
  if (parameters) {
    
    var kml_uri = parameters['kml_uri'];
    
    google.load("earth", "1", {
      callback: function() {
        google.earth.createInstance('earth_viewer', function(instance){
          
          instance.getWindow().setVisibility(true);
          
          // add a navigation control
          instance.getNavigationControl().setVisibility(instance.VISIBILITY_AUTO);
          var link = instance.createLink('');
          var href = kml_uri;
          link.setHref(href);
          
          var networkLink = instance.createNetworkLink('');
          networkLink.set(link, true, true); // Sets the link, refreshVisibility, and flyToView
          
          instance.getFeatures().appendChild(networkLink);
        }, function(errorCode){
          // do nothing
        });
      }
    });
    
  }
}
