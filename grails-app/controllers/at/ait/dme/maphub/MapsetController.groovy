package at.ait.dme.maphub

class MapsetController {
    
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
        
        def mapsets = Mapset.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
          and {
            eq('isPublic', true)
          }
        }
        
        params.totalMapsets = mapsets.totalCount
        [ mapsetInstanceList : mapsets, mapsetInstanceTotal : mapsets.totalCount, params: params ]
    }

    def create = {
        def mapsetInstance = new Mapset()
        mapsetInstance.properties = params
        return [mapsetInstance: mapsetInstance]
    }

    def save = {
        def mapsetInstance = new Mapset(params)
        if (mapsetInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'mapset.label', default: 'Mapset'), mapsetInstance.id])}"
            redirect(action: "show", id: mapsetInstance.id)
        }
        else {
            render(view: "create", model: [mapsetInstance: mapsetInstance])
        }
    }

    def edit = {
        def mapsetInstance = Mapset.get(params.id)
        if ((!mapsetInstance) || (mapsetInstance.user != springSecurityService.getCurrentUser())) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapset.label', default: 'Mapset'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [mapsetInstance: mapsetInstance]
        }
    }

    def update = {
        def mapsetInstance = Mapset.get(params.id)
        if ((mapsetInstance) && (mapsetInstance.user == springSecurityService.getCurrentUser())) {
            if (params.version) {
                def version = params.version.toLong()
                if (mapsetInstance.version > version) {
                    
                    mapsetInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'mapset.label', default: 'Mapset')] as Object[], "Another user has updated this Mapset while you were editing")
                    render(view: "edit", model: [mapsetInstance: mapsetInstance])
                    return
                }
            }
            mapsetInstance.properties = params
            if (!mapsetInstance.hasErrors() && mapsetInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'mapset.label', default: 'Mapset'), mapsetInstance.id])}"
                redirect(action: "show", id: mapsetInstance.id)
            }
            else {
                render(view: "edit", model: [mapsetInstance: mapsetInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapset.label', default: 'Mapset'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def mapsetInstance = Mapset.get(params.id)
        if ((mapsetInstance) && (mapsetInstance.user == springSecurityService.getCurrentUser())) {
            try {
                mapsetInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'mapset.label', default: 'Mapset'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'mapset.label', default: 'Mapset'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'mapset.label', default: 'Mapset'), params.id])}"
            redirect(action: "list")
        }
    }
}
