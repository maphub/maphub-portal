<head>
<title><g:message code='spring.security.ui.login.title'/></title>
<!-- <meta name='layout' content='register'/> -->
<meta name='layout' content='main'/>
</head>

<body>

<div style='text-align:center;' id="pageBody">


	<form action='${postUrl}' method='POST' id="loginForm" name="loginForm" autocomplete='off'>


	<h1>Log in</h1>

<p>
  <label for="username"><g:message code='spring.security.ui.login.username'/></label>
			<input name="j_username" id="username" size="20" />
<br/>

<label for="password"><g:message code='spring.security.ui.login.password'/></label>
  <input type="password" name="j_password" id="password" size="20" />
</p>

<p>
<!-- <s2ui:submitButton elementId='loginButton' form='loginForm' messageCode='spring.security.ui.login.login'/> -->
<input type="submit" value="Login">
</p>

<p>
    <input type="checkbox" class="checkbox" name="${rememberMeParameter}" id="remember_me" checked="checked" />
    <label for='remember_me'><g:message code='spring.security.ui.login.rememberme'/></label><br/>

    <span class="forgot-link">
      <g:link controller='register' action='forgotPassword'><g:message code='spring.security.ui.login.forgotPassword'/></g:link>
    </span>
    |
    <s2ui:linkButton elementId='register' controller='register' messageCode='spring.security.ui.login.register'/>
</p>



	</form>

</div>

<script>
$(document).ready(function() {
	$('#username').focus();
});

<s2ui:initCheckboxes/>

</script>

</body>
