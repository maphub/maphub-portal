<html>
    <head>
        <title>Welcome to MapHub</title>
        <meta name="layout" content="main" />
    </head>
    <body>
        <div id="pageBody">
          
                  <!-- Introduction image -->
        <div id="introduction">
        </div>
          
            <!-- INTRODUCTION TEXT -->
            <h1>Welcome to MapHub</h1>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                
                <!-- DEBUGGING -->
                <h2>Available Controllers:</h2>
                <ul>
                    <g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">
                        <li class="controller"><g:link controller="${c.logicalPropertyName}">${c.fullName}</g:link></li>
                    </g:each>
                </ul>
        </div>
    </body>
</html>
