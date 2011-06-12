package at.ait.dme.maphub

class AnnotationController {

    def springSecurityService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def browse = {
      params.max = Math.min(params?.max?.toInteger() ?: 20, 200)
      params.offset = params?.offset?.toInteger() ?: 0
      params.sort = params?.sort ?: "uploadDate"
      params.order = params?.order ?: "desc"
    
      def annotations = Annotation.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {}
      
      [ annotationInstanceList : annotations, params: params, annotationInstanceTotal : annotations.totalCount ]
    }
    
    def create = {
        def annotationInstance = new Annotation()
        annotationInstance.uploadDate = new Date()
        annotationInstance.editDate = new Date()
        annotationInstance.properties = params
        return [annotationInstance: annotationInstance]
    }

    def save = {
        def annotationInstance = new Annotation(params)
        annotationInstance.editDate = new Date()
        if (params.uploadDate == null) {
          annotationInstance.uploadDate = new Date()
        }
        annotationInstance.user = springSecurityService.getCurrentUser()
        Map.get(params.map).addToAnnotations(annotationInstance)
        
        if (annotationInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'annotation.label', default: 'Annotation'), annotationInstance.id])}"
            redirect(action: "show", id: annotationInstance.id)
        }
        else {
            render(view: "create", model: [annotationInstance: annotationInstance])
        }
    }

    def show = {
        def annotationInstance = Annotation.get(params.id)
        if (!annotationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
            redirect(action: "list")
        }
        else {
            [annotationInstance: annotationInstance]
        }
    }

    def edit = {
        def annotationInstance = Annotation.get(params.id)
        if (!annotationInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [annotationInstance: annotationInstance]
        }
    }

		def serialize = {
			def annotationInstance = Annotation.get(params.id)
			String rdfAnnotation = annotationInstance.serialize()
			render(contentType:"text/xml", text: rdfAnnotation)
		}

    def update = {
        def annotationInstance = Annotation.get(params.id)
        if (annotationInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (annotationInstance.version > version) {
                    
                    annotationInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'annotation.label', default: 'Annotation')] as Object[], "Another user has updated this Annotation while you were editing")
                    render(view: "edit", model: [annotationInstance: annotationInstance])
                    return
                }
            }
            annotationInstance.properties = params
            if (!annotationInstance.hasErrors() && annotationInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'annotation.label', default: 'Annotation'), annotationInstance.id])}"
                redirect(action: "show", id: annotationInstance.id)
            }
            else {
                render(view: "edit", model: [annotationInstance: annotationInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def annotationInstance = Annotation.get(params.id)
        if (annotationInstance) {
            try {
                annotationInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'annotation.label', default: 'Annotation'), params.id])}"
            redirect(action: "list")
        }
    }
}
