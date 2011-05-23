<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'mapset.label', default: 'Mapset')}" />
        <title>New Set</title>
        
        <script type="text/javascript">
          $(document).ready(function(){
            
            $(".singleMapInfo input").hide();
            
            $(".singleMapContainer").hover(function(){
              // $(this).css("background-color", "#ddd");
              $(this).addClass("highlighted");
            }, function(){
              var box = $(this).find("input").first();
              if (box.is(':checked')) {
                
              } else {
                $(this).removeClass("highlighted");
              }
            });
            
            $(".singleMapContainer").click(function(){
              var box = $(this).find("input").first();
              if (box.is(':checked')) {
                box.attr("checked", false);
                $(this).removeClass("fixed");
              } else {
                box.attr("checked", true);
                $(this).addClass("fixed");
              }
            });
            
          });
        </script>
        
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
              
              <p>Here you can select the maps that should belong to this set. Click a map to select it, click again to un-select.</p>
              
              <div class="mapList">
                <g:each in="${mapList}" var="map">
                  <div class="singleMapContainer">
                    <div class="singleMapInfo">
                      <g:link action="show" controller="map" id="${map.id}" >${map.name}</g:link><br>
                      <prettytime:display date="${map.uploadDate}" />
                      <g:thumbnail map="${map}"/>
                      <input type="checkbox" name="mapIds" value="${map.id}"/>
                    </div>
                  </div>
                </g:each>
              </div>
              
              <input type="hidden" name="maps" value=""/>
              
              <p><input type="submit" value="Create Set"/></p>
              
              <g:if test="${edit}">
                <input type="hidden" value="${edit}" name="edit">
              </g:if>
            </g:form>
        </div>
    </body>
</html>
