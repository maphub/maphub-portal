<html>
    <head>
        <title>${mapsetInstance.name}</title>
        <meta name="layout" content="main" />
    </head>
    <body>

      <h1>Maps in ${mapsetInstance.name}</h1>

          <div class="mapList">
            <g:each in="${mapsetInstance.maps}" var="map">
              <div class="singleMapContainer">
                <div class="singleMapInfo">
                  <g:link action="browse" controller="map">${map.name}</g:link>
                </div>
              </div>
            </g:each>
          </div>
          
          <div class="todo">Upload some maps for this set and then tweak this view</div>
          
    </body>
</html>
