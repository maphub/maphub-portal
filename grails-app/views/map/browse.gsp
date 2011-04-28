<html>
    <head>
        <title>Browsing Maps</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>Browsing Maps</h1>
          
          <p>There are already ${mapInstanceTotal} maps uploaded to MapHub!</p>
          
          <div class="mapList">
            <g:each in="${mapInstanceList}" var="map">
              <div class="singleMapContainer">
                <g:link action="show" controller="map" id="${map.id}"><g:thumbnail map="${map}"/></g:link>
              </div>
            </g:each>
          </div>
          
          <div class="paginateButtons">
              <g:paginate controller="map" action="browse" total="${mapInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
