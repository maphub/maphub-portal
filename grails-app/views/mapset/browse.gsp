<html>
    <head>
        <title>Browsing Map Sets</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>

            <g:form action="browse" controller="mapset" name="filterBoxForm">
              <label for="sort">Sort by</label>
              <g:select name="sort" from="${['name','date','user']}" value="${params.sort}"/>&nbsp;&nbsp;
              <label for="order">ordered by</label>
              <g:select name="order" from="${['asc', 'desc']}" value="${params.order}"/>&nbsp;&nbsp;
              <label for="max"> sets per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>
          
          
          
          <div class="mapList">
            <g:each in="${mapsetInstanceList}" var="mapset">
              <div class="singleMapContainer">
                <div class="singleMapInfo">
                  <g:link action="browse" controller="map">${mapset.name}</g:link><br>
                  Uploaded by <g:rep user="${mapset.user}"/></div>
              </div>
            </g:each>
          </div>
          
          <div class="todo">Upload some sets and then tweak this view</div>
          
          <div class="paginateButtons">
              <g:paginate controller="mapset" action="browse" total="${mapsetInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
