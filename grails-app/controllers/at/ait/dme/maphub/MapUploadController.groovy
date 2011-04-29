package at.ait.dme.maphub

class MapUploadController {

		def springSecurityService

    def index = { }

		def upload = {
			def createdMap = new Map(
				tilesetUrl: params.tilesetUrl,
				name: params.name,
				description: params.description,
				uploadDate: new Date(),
				mapDate: new Date(),
				user: springSecurityService.getCurrentUser())
			createdMap.save(flush:true)
		}

}
