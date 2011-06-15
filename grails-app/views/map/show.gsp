<html>
    <head>
        <title>${mapInstance.name}</title>
        <meta name="layout" content="main" />
        <g:javascript library="showmap" />
        <script type="text/javascript">
          
          $(document).ready(function(){
            $("#footer").hide();
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
        		(clientHeight - 600) + "px",
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
            Default&nbsp;|&nbsp;
            <g:link action="fullscreen" controller="map" id="${mapInstance.id}">Full Screen</g:link>
          </div><br><br>
          <h1>${mapInstance.name}</h1>
          <div id="viewer">Whoops, you don't seem to have Flash installed.</div>
          <hr>
            <h3>Details</h3>
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
              <tr>
                            <td class="left">
                              <div class="detailInfoObject">
                                <strong>Description:</strong> <markdown:renderHtml>${mapInstance.description}</markdown:renderHtml>
                              </div>
                            </td>
                            <td class="right">
                              <div class="detailInfoObject "> </div>
                            </td>
                          </tr>  
            </table>
            </div>
            <!-- <div id="detailInfoFollowing">
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
                        </div> -->
          </div>
          <div id="annotations">
            <h3>Annotations</h3>
            <p><g:link controller="annotation" action="create" params="${[mapId: mapInstance.id]}">Create a new Annotation ...</g:link></p>
            <ul>
            <g:each in="${mapInstance.annotations}" var="annotation">
              <li><strong><g:link controller="annotation" action="show" id="${annotation.id}">${annotation.title}</g:link></strong>, by 
              <g:link action="show" controller="profile" id="${annotation.user.id}">${annotation.user.username}</g:link>&nbsp;<g:rep user="${annotation.user}"/>, <prettytime:display date="${annotation.uploadDate}"/>  
              </li>
            </g:each>
            </ul>
          </div>
    </body>
</html>