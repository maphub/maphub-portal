<html>
    <head>
        <title>New Annotation</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>New Annotation</h1>
          
          <g:hasErrors>
            <div class="errors">
              <g:renderErrors bean="${annotation}" as="list" />
            </div>
          </g:hasErrors>
          
          <p>Here you can create a new annotation. It appears on the following Map:</p>
                <div class="singleMapInfo">
                  <g:link action="show" controller="map" id="${map.id}" >${map.name}</g:link><br>
                  <prettytime:display date="${map.uploadDate}" />, uploaded by <g:link action="show" controller="profile" id="${map.user.id}">${map.user.username}</g:link>&nbsp;<g:rep user="${map.user}"/><br>
                <g:link action="show" controller="map" id="${map.id}"><g:thumbnail map="${map}"/></g:link>
              </div>

          <hr>
          <br>
          <g:form action="save" class="genericForm">
            <p>
              <label for="title">Title</label>
              <input name="title"/>
            </p>
            <br/>
            <p>
              <label for="body">Annotation:</label>
              <textarea rows="10" cols="60" maxlength="700" name="body"></textarea>
            </p>
            <p><input type="submit"/></p>
            <input type="hidden" name="mapId" value="${params.mapId}">
          </g:form>
          
    </body>
</html>