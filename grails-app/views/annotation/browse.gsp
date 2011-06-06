<html>
    <head>
        <title>Browsing Annotations</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>

            <g:form action="browse" controller="annotation" name="filterBoxForm">
              <label for="sort">Sort by</label>
              <g:select name="sort" from="${['uploadDate', 'editDate']}" value="${params.sort}"/>&nbsp;&nbsp;
              <label for="order">ordered by</label>
              <g:select name="order" from="${['asc', 'desc']}" value="${params.order}"/>&nbsp;&nbsp;
              <label for="max"> users per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>
                    
          <div class="annotationList">
            <g:each in="${annotationInstanceList}" var="annotation">
              <div class="annotationContainer">
                <g:link action="show" controller="annotation" id="${annotation.id}"></g:link>
              </div>
            </g:each>
          </div>
          
          <div class="paginateButtons">
              <g:paginate controller="user" action="browse" total="${annotationInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
