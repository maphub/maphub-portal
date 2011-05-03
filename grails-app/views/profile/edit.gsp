<html>
    <head>
        <title>Edit Profile</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>Edit Profile</h1>
          
          <g:hasErrors>
            <div class="errors">
              <g:renderErrors bean="${user}" as="list" />
            </div>
          </g:hasErrors>
          
          <p>Here you can edit your profile details.</p>
          
          <g:form name="editProfileForm" controller="profile" action="update" class="genericForm">
            <p>
              <label for="username">Username:</label>
              <input name="username" value="${user.username}"/>
            </p>
            <p>
              <label for="description">About me:</label>
              <textarea rows="10" cols="60" name="description">${user.description}</textarea>
            </p>
            
            <p>If you want to change your password, type it twice, otherwise leave it blank.</p>
            <p>
              <label for="password">Password:</label>
              <input type="password" name="password"/>
            </p>
            <p>
              <label for="password2">Password (repeat):</label>
              <input type="password" name="password2"/>
            </p>
            
            <br>
            <p><input type="submit"/></p>
            
          </g:form>
          
    </body>
</html>
