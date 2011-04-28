<html>
    <head>
        <title>Map</title>
        <meta name="layout" content="main" />
        <script type="text/javascript">
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
        		(clientHeight - 510) + "px",
        		"9.0.0",
        		false,
        		{ source : "${mapInstance.tilesetUrl}/ImageProperties.xml" },
        		swfParams
        	);
          }
        </script>

    </head>
    <body>
        <div id="pageBody">
          <div id="viewer"></div>
                    <p>Uploaded by ${mapInstance.user.username}</p>
        </div>
    </body>
</html>
