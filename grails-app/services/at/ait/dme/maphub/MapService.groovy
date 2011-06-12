package at.ait.dme.maphub

import at.ait.dme.yuma.server.model.Annotation
import at.ait.dme.yuma.server.model.MediaType
import at.ait.dme.yuma.server.model.User
import at.ait.dme.yuma.server.formathandler.rdf.oac.OACFormatHandler

class MapService {
  
	String serializeOAC(at.ait.dme.maphub.Annotation annotationEntity) {
		String annotationId = annotationEntity.id.toString()
		User user = new User(annotationEntity.user.username)
		String objectUri = findAnnotatedMap(annotationEntity).tilesetUrl

		// TODO: replace hardcoded annotation uri by annotation controller path
		Annotation annotation = new Annotation("http://some.annotation.com/1", user, MediaType.IMAGE)
		annotation.addObjectUri(objectUri)
		return new OACFormatHandler().serialize(annotation)
	}

	Map findAnnotatedMap(at.ait.dme.maphub.Annotation annotationEntity) {
		return Map.findAllByAnnotations(annotationEntity)
	}

}
