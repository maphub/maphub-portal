<html>
    <head>
        <title>Browsing Maps</title>
        <meta name="layout" content="main" />
    </head>
    <body>
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>

            <g:form action="browse" controller="map" name="filterBoxForm">
              <label for="sort">Sort by</label>
              <g:select name="sort" from="${['name','date','user']}" value="${params.sort}"/>&nbsp;&nbsp;
              <label for="order">ordered by</label>
              <g:select name="order" from="${['asc', 'desc']}" value="${params.order}"/>&nbsp;&nbsp;
              <label for="max"> maps per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>
          <div id="viewTypeBox">
            <strong>View as:</strong> 
            Thumbnails&nbsp;|&nbsp;
            <g:link action="list" controller="map" params="${params}">List</g:link>
          </div>
          
          <div class="mapList">
            <g:each in="${mapInstanceList}" var="map">
              <div class="singleMapContainer">
                <div class="singleMapInfo"><g:link action="show" controller="map" id="${map.id}">${map.name}</g:link>, uploaded by <g:link action="show" controller="user" id="${map.user.id}">${map.user.username}</g:link></div>
                <g:link action="show" controller="map" id="${map.id}"><g:thumbnail map="${map}"/></g:link>
              </div>
            </g:each>
          </div>
          
          <div class="paginateButtons">
              <g:paginate controller="map" action="browse" total="${mapInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
