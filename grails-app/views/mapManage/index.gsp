<html>
    <head>
        <title>Manage Maps</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>Manage Maps</h1>
          <p>Here you can manage all your maps and sets. You can upload some more, delete old ones, move them to a set, etc.</p>
          
          <h3>Uploading Maps and Sets</h3>
          <ul>
            <li><g:link action="create" controller="mapset">Create a new Set</g:link></li>
            <li><g:link action="index" controller="mapupload">Upload a new Map</g:link></li>
          </ul>
          
          <h3>Your Content</h3>
          <ul>
            <li><g:link action="browse" controller="mapset" params="${[user : user.id]}">Browse my Sets</g:link></li>
            <li><g:link action="browse" controller="map" params="${[user : user.id]}">Browse my Maps</g:link></li>
          </ul>
          
          <div class="todo">Find a few things to implement here.</div>
          
    </body>
</html>
