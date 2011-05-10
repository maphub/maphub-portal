

<%@ page import="at.ait.dme.maphub.Mapset" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'mapset.label', default: 'Mapset')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${mapsetInstance}">
            <div class="errors">
                <g:renderErrors bean="${mapsetInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${mapsetInstance?.id}" />
                <g:hiddenField name="version" value="${mapsetInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="name"><g:message code="mapset.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: mapsetInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${mapsetInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="description"><g:message code="mapset.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: mapsetInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${mapsetInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="isPublic"><g:message code="mapset.isPublic.label" default="Is Public" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: mapsetInstance, field: 'isPublic', 'errors')}">
                                    <g:checkBox name="isPublic" value="${mapsetInstance?.isPublic}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="maps"><g:message code="mapset.maps.label" default="Maps" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: mapsetInstance, field: 'maps', 'errors')}">
                                    <g:select name="maps" from="${at.ait.dme.maphub.Map.list()}" multiple="yes" optionKey="id" size="5" value="${mapsetInstance?.maps*.id}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="user"><g:message code="mapset.user.label" default="User" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: mapsetInstance, field: 'user', 'errors')}">
                                    <g:select name="user.id" from="${at.ait.dme.maphub.User.list()}" optionKey="id" value="${mapsetInstance?.user?.id}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
