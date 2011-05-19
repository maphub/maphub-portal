<html>
    <head>
        <title>Browsing Users</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>

            <g:form action="browse" controller="user" name="filterBoxForm">
              <label for="sort">Sort by</label>
              <g:select name="sort" from="${['username', 'reputation']}" value="${params.sort}"/>&nbsp;&nbsp;
              <label for="order">ordered by</label>
              <g:select name="order" from="${['asc', 'desc']}" value="${params.order}"/>&nbsp;&nbsp;
              <label for="max"> users per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>
                    
          <div class="userList">
            <g:each in="${userInstanceList}" var="user">
              <div class="singleUserContainer">
                <div class="singleUserInfo">
                  <div class="userAvatarSmall">
                    <g:link action="show" controller="profile" id="${user.id}">
                    <avatar:gravatar email="${user.email}" size="50"/>
                    </g:link>
                  </div>
                  <div class="userName">
                    <g:link action="show" controller="profile" id="${user.id}">${user.username}</g:link>
                  </div>
                  <g:rep user="${user}"/>
                </div>
              </div>
            </g:each>
          </div>
          
          <div class="paginateButtons">
              <g:paginate controller="user" action="browse" total="${userInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
