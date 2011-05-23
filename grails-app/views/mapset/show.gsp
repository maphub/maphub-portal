<html>
    <head>
        <title>${mapsetInstance.name}</title>
        <meta name="layout" content="main" />
    </head>
    <body>

      <h1>Maps in ${mapsetInstance.name}</h1>

      <p>This is a set created by <g:link action="show" controller="profile" id="${mapsetInstance.user.id}">${mapsetInstance.user.username}</g:link>&nbsp;<g:rep user="${mapsetInstance.user}"/>, last edited <prettytime:display date="${mapsetInstance.editDate}"/> (originally created <prettytime:display date="${mapsetInstance.uploadDate}"/>).</p>

          <div class="mapList">
            <g:each in="${mapsetInstance.maps}" var="map">
              <div class="singleMapContainer">
                <div class="singleMapInfo">
                  <g:link action="show" controller="map" id="${map.id}" >${map.name}</g:link><br>
                  <prettytime:display date="${map.uploadDate}" />
                </div>
                <g:link action="show" controller="map" id="${map.id}"><g:thumbnail map="${map}"/></g:link>
              </div>
            </g:each>
          </div>
          
    </body>
</html>
