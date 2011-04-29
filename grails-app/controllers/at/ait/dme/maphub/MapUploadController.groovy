package at.ait.dme.maphub

class MapUploadController {

		def springSecurityService

    def index = {
		}

		def upload = {
			def createdMap = new Map(params)

			createdMap.uploadDate = new Date()
			createdMap.mapDate = new Date()
			createdMap.user = springSecurityService.getCurrentUser()
			createdMap.views = 0

			if (createdMap.validate()) {
println "mapname: "+createdMap.name
				createdMap.save(flush:true)
				redirect(controller: 'map', action: 'browse')
			}
			else {
				render(view: 'index', model: [ map : createdMap ])
			}
		}

}
