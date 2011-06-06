<!DOCTYPE html>
<html>
    <head>
        <title><g:layoutTitle default="MapHub" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:javascript library="application" />
        <g:javascript library="swfobject" />
        <g:javascript library="jquery" />
        <g:layoutHead />
    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="${message(code:'spinner.alt',default:'Loading...')}" />
        </div>

				<!-- replace with maphub logo 
        <div id="grailsLogo"><a href="http://grails.org"><img src="${resource(dir:'images',file:'grails_logo.png')}" alt="Grails" border="0" /></a></div> -->

        <!-- Search field -->
        <div id="search">
          <script type="text/javascript">
          function submitQuery() { document.forms["queryString"].submit(); }
          </script>

          <g:form action="index" controller="siteSearch" name="queryString">
            <g:textField name="q" />
            <a href="javascript: submitQuery();">Search</a>
          </g:form>
        </div>

      <!-- User Action bar -->
      <div id="usertools">
        <sec:ifNotLoggedIn>
          <g:link controller='login' action='auth'>Login</g:link>
        </sec:ifNotLoggedIn>
        <sec:ifLoggedIn>
          <g:link controller="profile"><sec:loggedInUserInfo field="username"/></g:link>
          <!-- TODO insert the reputation here? -->
          | <g:link controller='logout'>Logout</g:link>
        </sec:ifLoggedIn>
        <sec:ifAnyGranted roles="ROLE_ADMIN">
            | <g:link controller='admin'>Admin Area</g:link>
        </sec:ifAnyGranted>
      </div>

        <!-- Header text/logo -->
        <div id="header">
          <a href="/maphub-portal">MapHub</a>
        </div>

        
        
        <sec:ifLoggedIn>
        <!-- Navigation -->
        <div id="navigation">
          <ul>
            <li><a href="/maphub-portal">Home</a></li>
            <li><g:link action="browse" controller="map">Maps</g:link></li>
            <li><g:link action="browse" controller="mapset">Sets</g:link></li>
            <li><g:link action="browse" controller="annotation">Annotations</g:link></li>
            <li><g:link action="browse" controller="user">Users</g:link></li>
            <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER_RW">
              <li class="right"><g:link action="index" controller="mapUpload">Upload Map</g:link></li>
              <li class="right"><g:link action="index" controller="mapManage">Manage Maps/Sets</g:link></li>
            </sec:ifAnyGranted>
          </ul>
        </div>
        </sec:ifLoggedIn>
        
        <!-- Main contents -->
        <div id="main">
          <g:layoutBody />
        </div>
        
        <!-- Footer -->
        <div id="footer">
          <div>
            <div id="about">
            <h3>About MapHub</h3>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </div> <!-- end about -->
          
          <div id="links">
            <h3>Useful Links</h3>
            <ul>
              <li><g:link controller="home" action="help">Help</g:link></li>
              <li><g:link controller="home" action="contact">Contact</g:link></li>
              <li><g:link controller="home" action="tos">Terms Of Service</g:link></li> 
            </ul>
          </div> <!-- end links -->
        </div> <!-- end footer div -->

    </body>
</html>
