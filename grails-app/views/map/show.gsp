<html>
    <head>
        <title>Map</title>
        <meta name="layout" content="main" />
        <g:javascript library="showmap" />
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
        		(clientHeight - 440) + "px",
        		"9.0.0",
        		false,
        		{ source : "${mapInstance.tilesetUrl}/ImageProperties.xml" },
        		swfParams
        	);
          }
        </script>
    </head>
    <body>
          <div id="detailInfo">
            <div id="detailInfoFirst">
            <table>
              <tr>
                <td class="left">
                  <div class="detailInfoObject"><strong>Name:</strong> ${mapInstance.name}</div>
                </td>
                <td class="right">
                  <div class="detailInfoObject"><strong>Uploaded by: </strong> <g:link action="show" controller="profile" id="${mapInstance.user.id}">${mapInstance.user.username}</g:link>&nbsp;<g:rep user="${mapInstance.user}"/>, <prettytime:display date="${mapInstance.uploadDate}" showTime="true" format="HH:mm:ss"/></div>
                </td>
              </tr>
            </table>
            </div>
            <div id="detailInfoFollowing">
            <table>
              <tr>
                <td class="left">
                  <div class="detailInfoObject">
                    <markdown:renderHtml>${mapInstance.description}</markdown:renderHtml>
                  </div>
                </td>
                <td class="right">
                  <div class="detailInfoObject "> </div>
                </td>
              </tr>  
            </table>
            </div>
          </div>
          <div id="viewer">Whoops, you don't seem to have Flash installed.</div>
    </body>
</html>
