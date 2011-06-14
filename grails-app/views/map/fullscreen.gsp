<html>
    <head>
        <title>${mapInstance.name}</title>
        <meta name="layout" content="main" />
        <g:javascript library="showmap" />
        <script type="text/javascript">
          
          $(document).ready(function(){
            $("#header, #footer, #navigation, #usertools, #search").hide();
            $("body").css("width", "95%");
          });
        
          var path = "${mapInstance.tilesetUrl}";
          
          var swfParams = {
        	movie: "OpenZoomViewer.swf",
        	scale: "noscale",
        	bgcolor: "#ffffff",
        	allowfullscreen: "true",
        	allowscriptaccess: "always"
          };
  
          window.onresize = function() {
            showMap();
          }
  
          window.onload = function() {
            showMap();
          }
  
          function showMap() {
            var clientHeight = document.documentElement.clientHeight;

            swfobject.embedSWF("${resource(dir:'',file:'OpenZoomViewer.swf')}", 
        		"viewer",
        		"100%", 
        		(clientHeight - 200) + "px",
        		"9.0.0",
        		false,
        		{ source : "${mapInstance.tilesetUrl}/ImageProperties.xml" },
        		swfParams
        	);
          }
        </script>
    </head>
    <body>
          <div id="viewTypeBox">
            <strong>View as:</strong> 
            <g:link action="show" controller="map" id="${mapInstance.id}">Default</g:link>&nbsp;|&nbsp;
            Full Screen
          </div>
          <div id="viewer">Whoops, you don't seem to have Flash installed.</div>
    </body>
    
</html>
