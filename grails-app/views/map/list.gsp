
<%@ page import="at.ait.dme.maphub.Map" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="body">
          <div id="filterBox">
            <script type="text/javascript">
              function submitFilter() { document.forms["filterBoxForm"].submit(); }
            </script>
            
            <g:form action="list" controller="map" name="filterBoxForm">
              <label for="max">Maps per page:</label>
              <g:select name="max" from="${[20, 50, 100, 200]}" value="${params.max}"/>&nbsp;&nbsp;
              <!-- <g:submitButton name="filter" value="Apply" /> -->
              <a href="javascript: submitFilter();">Apply</a>
           </g:form>
          </div>

          <div id="viewTypeBox">
            <strong>View as:</strong> 
            <g:link action="browse" controller="map" params="${params}">Thumbnails</g:link>&nbsp;|&nbsp;
            List
          </div>
          

            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'map.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'map.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'map.description.label', default: 'Description')}" />

                            <g:sortableColumn property="tilesetUrl" title="${message(code: 'map.tilesetUrl.label', default: 'Tileset Url')}" />
                        
                        
                            <g:sortableColumn property="mapDate" title="${message(code: 'map.mapDate.label', default: 'Map Date')}" />
                        
                            <g:sortableColumn property="uploadDate" title="${message(code: 'map.uploadDate.label', default: 'Upload Date')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${mapInstanceList}" status="i" var="mapInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${mapInstance.id}">${fieldValue(bean: mapInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: mapInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: mapInstance, field: "description")}</td>

                            <td>${fieldValue(bean: mapInstance, field: "tilesetUrl")}</td>                        
                        
                            <td><g:formatDate date="${mapInstance.mapDate}" /></td>
                                              
                            <td><g:formatDate date="${mapInstance.uploadDate}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${mapInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
