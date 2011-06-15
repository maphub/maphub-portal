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
              <g:select name="sort" from="${['title', 'uploadDate', 'editDate']}" value="${params.sort}"/>&nbsp;&nbsp;
              <label for="order">ordered by</label>
              <g:select name="order" from="${['asc', 'desc']}" value="${params.order}"/>&nbsp;&nbsp;
              <label for="max"> Annotations per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>
                    
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'annotation.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="title" title="${message(code: 'annotation.title.label', default: 'Title')}" />
                        
                            <g:sortableColumn property="map" title="${message(code: 'annotation.map..name.label', default: 'Appears on')}" />
                        
                            <g:sortableColumn property="uploadDate" title="${message(code: 'annotation.uploadDate.label', default: 'Upload Date')}" />
                            
                            <g:sortableColumn property="editDate" title="${message(code: 'annotation.editDate.label', default: 'Edit Date')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${annotationInstanceList}" status="i" var="annotationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${annotationInstance.id}">${fieldValue(bean: annotationInstance, field: "id")}</g:link></td>
                        
                            <td><g:link action="show" id="${annotationInstance.id}">${fieldValue(bean: annotationInstance, field: "title")}</g:link></td>
                            
                            <td><g:link action="show" controller="map" id="${annotationInstance.map.id}">${annotationInstance.map.name}</g:link></td>
                                              
                            <td><g:formatDate date="${annotationInstance.uploadDate}" /></td>
                        
                            <td><g:formatDate date="${annotationInstance.editDate}" /></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            
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
