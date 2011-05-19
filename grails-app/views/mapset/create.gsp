<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'mapset.label', default: 'Mapset')}" />
        <title>New Set</title>
    </head>
    <body>
        <div class="body">
            <h1>Create a new Set</h1>

            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${mapsetInstance}">
              <div class="errors">
                  <g:renderErrors bean="${mapsetInstance}" as="list" />
              </div>
            </g:hasErrors>

            <g:form action="save" class="genericForm">
              <h3>Step 1 - Provide some details</h3>
                <p>
                  <label for="name">Set Name:</label>
                  <g:textField name="name"/>
                </p>

                <p>
                  <label for="description">Set Description:</label>
                  <g:textArea name="description" rows="10" cols="60"/>
                </p>

                <p>
                  <label for="isPublic">This set is visible to all users</label>
                  <g:checkBox name="isPublic" checked="true"/>
                </p>
              <h3>Step 2 - Select the Maps</h3>
              
              <div class="todo">TODO: Selection for maps</div>
              
              <input type="submit" value="Create Set"/>
              
              <g:if test="${edit}">
                <input type="hidden" value="${edit}" name="edit">
              </g:if>
            </g:form>
            
        </div>
    </body>
</html>
