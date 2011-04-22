<!DOCTYPE html>
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
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
				<div id="userInfo">
					<sec:ifNotLoggedIn>
						Click here to
						<g:link controller='login' action='auth'>login</g:link>
					</sec:ifNotLoggedIn>
					<sec:ifLoggedIn>
						Logged in as
						<sec:loggedInUserInfo field="username"/>
						(<g:link controller='logout'>Logout</g:link>)
					</sec:ifLoggedIn>
				</div>
        <g:layoutBody />
    </body>
</html>
