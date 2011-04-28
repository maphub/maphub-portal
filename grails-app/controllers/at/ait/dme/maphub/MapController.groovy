package at.ait.dme.maphub

class MapController {

    def mapService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [mapInstanceList: Map.list(params), mapInstanceTotal: Map.count()]
    }
    
    def browse = {
    
        params.max = Math.min(params?.max?.toInteger() ?: 10, 100)
        params.offset = params?.offset?.toInteger() ?: 0
        params.sort = params?.sort ?: "tilesetUrl"
        params.order = params?.order ?: "asc"
        
        def maps = Map.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {}
        
        params.totalMaps = maps.totalCount
        [ mapInstanceList : maps, mapInstanceTotal : maps.totalCount, params: params ]
      }

    
    def create = {
        def mapInstance = new Map()
        mapInstance.properties = params
        return [mapInstance: mapInstance]
    }

    def save = {
        def mapInstance = new Map(params)
        if (mapInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'map.label', default: 'Map'), mapInstance.id])}"
            redirect(action: "show", id: mapInstance.id)
        }
        else {
            render(view: "create", model: [mapInstance: mapInstance])
        }
    }

    def show = {
        def mapInstance = Map.get(params.id)
        if (!mapInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
        else {
            [mapInstance: mapInstance]
        }
    }

    def edit = {
        def mapInstance = Map.get(params.id)
        if (!mapInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [mapInstance: mapInstance]
        }
    }

    def update = {
        def mapInstance = Map.get(params.id)
        if (mapInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (mapInstance.version > version) {
                    
                    mapInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'map.label', default: 'Map')] as Object[], "Another user has updated this Map while you were editing")
                    render(view: "edit", model: [mapInstance: mapInstance])
                    return
                }
            }
            mapInstance.properties = params
            if (!mapInstance.hasErrors() && mapInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'map.label', default: 'Map'), mapInstance.id])}"
                redirect(action: "show", id: mapInstance.id)
            }
            else {
                render(view: "edit", model: [mapInstance: mapInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def mapInstance = Map.get(params.id)
        if (mapInstance) {
            try {
                mapInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
    }
}
