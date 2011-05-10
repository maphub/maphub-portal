<html>
    <head>
        <title>Browsing Maps</title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'contentflow.css')}" />
        <g:javascript library="contentflow" />
        <meta name="layout" content="main" />
    </head>
    <body>
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>

            <g:form action="coverflow" controller="map" name="filterBoxForm">
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
            <g:link action="browse" controller="map" params="${params}">Thumbnails</g:link>&nbsp;|&nbsp;
            <g:link action="list" controller="map" params="${params}">List</g:link>&nbsp;|&nbsp;
            Cover Flow
          </div>
          
          <div class="ContentFlow">
            <div class="loadIndicator"><div class="indicator"></div></div>
            <div class="flow">
              <g:each in="${mapInstanceList}" var="map">
                <g:coverflowItem map="${map}"/>
              </g:each>
            </div>
            <div class="globalCaption"></div>
            <div class="scrollbar">
              <div class="slider">
                <div class="position"></div>
              </div>
            </div>
          </div>
          
          <div class="paginateButtons">
              <g:paginate controller="map" action="coverflow" params="${params}" total="${mapInstanceTotal}"></g:paginate>
          </div>
    </body>
</html>
