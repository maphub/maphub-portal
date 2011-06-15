package at.ait.dme.maphub

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN', 'ROLE_USER_RW'])
class MapUploadController {

		def springSecurityService

    def index = {
		}

		def upload = {
			def createdMap = new Map(params)

			createdMap.uploadDate = new Date()
			createdMap.editDate = new Date()
			// createdMap.mapDate = new Date()
			def user = springSecurityService.getCurrentUser()
			createdMap.user = user
			
			createdMap.views = 0

			if (createdMap.validate()) {
        createdMap.description = createdMap.description.encodeAsHTML()
				createdMap.save(flush:true)
				redirect(controller: 'map', action: 'show', id: createdMap.id)
			}
			else {
				render(view: 'index', model: [ map : createdMap ])
			}
		}

}
