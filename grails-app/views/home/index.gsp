<html>
    <head>
        <title>Welcome to MapHub</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          
      <!-- IF LOGGED IN -->
      <sec:ifLoggedIn>
        
        <h1>Welcome back to MapHub!</h1>
        
        <h2>What's new</h2>
          <blockquote>
          MapHub is a portal environment for social annotation of digitized (historic) maps, powered by YUMA.
          </blockquote>
        
        <div style="width: 45%; float:left;">
        <h2>Recently uploaded maps</h2>
          <ul>
            <g:each in="${recentMaps}" var="map">
                <li>
                  <g:link action="show" controller="map" id="${map.id}">${map.name}</g:link>,
                  <prettytime:display date="${map.uploadDate}" /> by <g:link action="show" controller="user" id="${map.user.id}">${map.user.username}</g:link>
                </li>
            </g:each>
          </ul>
        </div>
        
        <div style="width: 45%; float:right;">
        <h2>This week's favorites</h2>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </div>
        
      </sec:ifLoggedIn>
      
      <!-- IF NOT LOGGED IN -->
      <sec:ifNotLoggedIn>
        <!-- Introduction image -->
        <div id="introduction"></div>
        
          <h1>Welcome to MapHub</h1>
          <blockquote>
          MapHub is a portal environment for social annotation of digitized (historic) maps, powered by YUMA.
          </blockquote>
<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
<p>Are you ready? <g:link action="browse" controller="map">Start browsing public maps now!</g:link></p>

      </sec:ifNotLoggedIn>

    </body>
</html>
