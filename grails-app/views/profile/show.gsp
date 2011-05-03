<html>
    <head>
        <title>Profile of ${user.username}</title>
        <meta name="layout" content="main" />
    </head>
    <body>
      <g:if test="${self}">
        <div id="userBox">
          Hey, ${user.username}, this is you!&nbsp;|&nbsp;<g:link controller="profile" action="edit">Edit Profile</g:link>
        </div>        
      </g:if>
      <h1>${user.username}</h1>
      
      <div class="userAvatarLarge">
        <img src="${resource(dir:'images',file:'avatar_large.png')}"/>
      </div>
      <div class="userInfoTableContainer">
        <table class="userInfoTable">
          <tr>
            <td class="firstCol">Reputation:</td>
            <td>${user.reputation}</td>
          </tr>
          <tr>
            <td class="firstCol">Joined:</td>
            <td><prettytime:display date="${user.registerDate}"/></td>
          </tr>
          <tr>
            <td class="firstCol">Last seen:</td>
            <td><prettytime:display date="${user.lastLoginDate}"/></td>
          </tr>
          <tr>
            <td class="firstCol">Uploaded maps:</td>
            <td>${mapsCount}</td>
          </tr>
        </table>
      </div>
      <hr>
      
      <div style="width: 45%; float:left;">
        <h2>Uploaded Maps</h2>
        <ul>
          <g:each in="${maps}" var="map">
            <li><g:link controller="map" action="show" id="${map.id}">${map.name}</g:link></li>
          </g:each>
        </ul>
        <g:if test="${mapsCount > 10}">
        <br>
          <p>... and many more!</p>
        </g:if>
      </div>
      
      <div style="width: 45%; float:right;">
        <g:if test="${user.description == ''}">
          <div class="message">
            Here could be a text about you! Why not <g:link controller="profile" action="edit">edit your profile</g:link> and add something interesting?
          </div>
        </g:if>
        <g:else>
          <h2>About myself</h2>
        <markdown:renderHtml>${user.description}</markdown:renderHtml>
        </g:else>
      </div>
      
      <br style="clear:both;">
      
    </body>
</html>
