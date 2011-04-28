package at.ait.dme.maphub

class MapController {

    def mapService

    // def scaffold = Map

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 20, 200)
        [mapInstanceList: Map.list(params), mapInstanceTotal: Map.count()]
    }
    
    def browse = {
    
        params.max = Math.min(params?.max?.toInteger() ?: 20, 200)
        params.offset = params?.offset?.toInteger() ?: 0
        params.sort = params?.sort ?: "uploadDate"
        params.order = params?.order ?: "desc"
        
        def maps = Map.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {}
        
        params.totalMaps = maps.totalCount
        [ mapInstanceList : maps, mapInstanceTotal : maps.totalCount, params: params ]
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


}
