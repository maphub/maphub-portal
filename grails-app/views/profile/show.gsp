<html>
    <head>
        <title>Profile of ${user.username}</title>
        <meta name="layout" content="main" />
    </head>
    <body>
      <div id="userBox">
        Hey, ${user.username}, this is you!&nbsp;|&nbsp;<g:link controller="profile" action="edit">Edit Profile</g:link>
      </div>
          <h1>${user.username}</h1>
          <p>Here is the profile of this user.</p>
    </body>
</html>
