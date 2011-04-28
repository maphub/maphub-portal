<html>
    <head>
        <title>Admin Area</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>MapHub Admin Area</h1>
          Here you can control various sections of MapHub.
          
          <ul>
            <li><g:link controller="user">User Management</g:link></li>
          </ul>
          
                    <!-- DEBUGGING -->
          <h2>Available Controllers:</h2>
          <ul>
              <g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">
                  <li class="controller"><g:link controller="${c.logicalPropertyName}">${c.fullName}</g:link></li>
              </g:each>
          </ul>
          
    </body>
</html>
