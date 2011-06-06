<html>
    <head>
        <title>Annotation ${annotationInstance.title}</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <h1>${annotationInstance.title}</h1>
          <p>
            ${annotationInstance.body}
          </p>
          <p>
            This is an annotation created by <g:link action="show" controller="profile" id="${annotationInstance.user.id}">${annotationInstance.user.username}</g:link>&nbsp;<g:rep user="${annotationInstance.user}"/>, last edited <prettytime:display date="${annotationInstance.editDate}"/> (originally created <prettytime:display date="${annotationInstance.uploadDate}"/>).
          </p>
          
    </body>
</html>