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
          
          <p>Here you can create a new annotation.</p>
          
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
            <input type="hidden" name="map" value="${params.map}">
          </g:form>
          
    </body>
</html>