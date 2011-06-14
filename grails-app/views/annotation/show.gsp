<html>
    <head>
        <title>Annotation ${annotationInstance.title}</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>${annotationInstance.title}</h1>
          <p>
            ${annotationInstance.body}
          </p>
          <hr>
          <h3>Details</h3>
          <p>
            This is an annotation created by <g:link action="show" controller="profile" id="${annotationInstance.user.id}">${annotationInstance.user.username}</g:link>&nbsp;<g:rep user="${annotationInstance.user}"/>, last edited <prettytime:display date="${annotationInstance.editDate}"/> (originally created <prettytime:display date="${annotationInstance.uploadDate}"/>).<br>
            It appears on the following Map:
          </p>
                <div class="singleMapInfo">
                  <g:link action="show" controller="map" id="${annotationInstance.map.id}" >${annotationInstance.map.name}</g:link><br>
                  <prettytime:display date="${annotationInstance.map.uploadDate}" />, uploaded by <g:link action="show" controller="profile" id="${annotationInstance.map.user.id}">${annotationInstance.map.user.username}</g:link>&nbsp;<g:rep user="${annotationInstance.map.user}"/>
                </div>
                <g:link action="show" controller="map" id="${annotationInstance.map.id}"><g:thumbnail map="${annotationInstance.map}"/></g:link>
              </div>
          
    </body>
</html>