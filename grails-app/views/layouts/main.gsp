<!DOCTYPE html>
<html>
    <head>
        <title><g:layoutTitle default="MapHub" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:layoutHead />
        <g:javascript library="application" />
    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="${message(code:'spinner.alt',default:'Loading...')}" />
        </div>

				<!-- replace with maphub logo 
        <div id="grailsLogo"><a href="http://grails.org"><img src="${resource(dir:'images',file:'grails_logo.png')}" alt="Grails" border="0" /></a></div> -->
				
      <!-- User Action bar -->
      <div id="usertools">
        <sec:ifNotLoggedIn>
          <g:link controller='login' action='auth'>Login</g:link>
        </sec:ifNotLoggedIn>
        <sec:ifLoggedIn>
          Welcome, 
          <sec:loggedInUserInfo field="username"/>
          (<g:link controller='logout'>Logout</g:link>)
        </sec:ifLoggedIn>
      </div>

        <!-- Header text/logo -->
        <div id="header">
          MapHub
        </div>
        
        <!-- Navigation -->
        <div id="navigation">
          <ul>
            <li><a href="/maphub-portal">Home</a></li>
            <li><g:link action="browse" controller="map">Browse Maps</g:link></li>.
            <li><a href="#">Users</a></li>
						<sec:ifAnyGranted roles="ROLE_ADMIN">
							<li id="adminarea">
								<g:link controller='user'>Admin Area</g:link>
							</li>
						</sec:ifAnyGranted>
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER_RW">
            	<li id="upload"><a href="#">Upload Map</a></li>
						</sec:ifAnyGranted>
          </ul>
        </div>
        
        <!-- Main contents -->
        <div id="main">
          <g:layoutBody />
        </div>
        
        <!-- Footer -->
        <div id="footer">
          <div>
            <div id="about">
            <h3>About MapHub</h3>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
          </div>
          
          <div id="links">
            <h3>Links</h3>
            <ul>
              <li><a href="#">Contact us</a></li>
              <li><a href="#">Terms of Service</a></li> 
            </ul>
          </div> <!-- end links -->
        </div> <!-- end footer div -->
        </div> <!-- end footer -->
    </body>
</html>
