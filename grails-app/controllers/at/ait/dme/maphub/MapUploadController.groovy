package at.ait.dme.maphub

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN', 'ROLE_USER_RO'])
class MapUploadController {

		def springSecurityService

    def index = {
		}

		def upload = {
			def createdMap = new Map(params)

			createdMap.uploadDate = new Date()
			// createdMap.mapDate = new Date()
			createdMap.user = springSecurityService.getCurrentUser()
			createdMap.views = 0

			if (createdMap.validate()) {
println "mapname: "+createdMap.name
				createdMap.save(flush:true)
				redirect(controller: 'map', action: 'show', id: createdMap.id)
			}
			else {
				render(view: 'index', model: [ map : createdMap ])
			}
		}

}
