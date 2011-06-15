package at.ait.dme.maphub

import at.ait.dme.yuma.server.model.Annotation
import at.ait.dme.yuma.server.model.MediaType
import at.ait.dme.yuma.server.model.User
import at.ait.dme.yuma.server.formathandler.rdf.oac.OACFormatHandler

class MapService {
  
	def grailsApplication

	String serializeOAC(at.ait.dme.maphub.Annotation annotationEntity) {
		String annotationId = annotationEntity.id.toString()
		User user = new User(annotationEntity.user.username)
		String objectUri = findAnnotatedMap(annotationEntity).tilesetUrl
		String annotationUri = getAnnotationUri(annotationEntity)

		Annotation annotation = new Annotation(annotationUri, user, MediaType.IMAGE)
		annotation.addObjectUri(objectUri)
		return new OACFormatHandler().serialize(annotation)
	}

	Map findAnnotatedMap(at.ait.dme.maphub.Annotation annotationEntity) {
		return Map.findAllByAnnotations(annotationEntity)
	}

	String getAnnotationUri(at.ait.dme.maphub.Annotation annotationEntity) {
		def g = grailsApplication.mainContext.getBean('org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib')
		g.createLink(controller:"Map", action: "show", id: annotationEntity.id, absolute: true)
	}

}
