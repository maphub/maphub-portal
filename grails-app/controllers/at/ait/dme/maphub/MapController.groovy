package at.ait.dme.maphub

class MapController {

    def mapService

    //def scaffold = Map

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    /* Generic function to load maps that can be used from all view methods */
    def loadMaps(params) {
      params.max = Math.min(params?.max?.toInteger() ?: 20, 200)
      params.offset = params?.offset?.toInteger() ?: 0
      params.sort = params?.sort ?: "uploadDate"
      params.order = params?.order ?: "desc"
      
      def maps
      
      /* If a set was specified */
      if (params.set != null) {
        maps = Map.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
           mapsets {
               eq('id', params.set)
           }
        }
      }
      /* If a user was specified */
      else if (params.user != null) {
        maps = Map.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
           user {
               eq('id', params.user)
           }
        }
      }
      /* If not, just load all public maps */
      else {
       maps = Map.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
          and {
            eq('isPublic', true)
          }
        } 
      }
        
      return maps
    }

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 20, 200)
        [mapInstanceList: Map.list(params), mapInstanceTotal: Map.count()]
    }
    
    def browse = {
        def maps = loadMaps(params)
        params.totalMaps = maps.totalCount
        [ mapInstanceList : maps, mapInstanceTotal : maps.totalCount, params: params ]
      }
    
    def coverflow = {
        def maps = loadMaps(params)
        params.totalMaps = maps.totalCount
        [ mapInstanceList : maps, mapInstanceTotal : maps.totalCount, params: params ]
    }
    
    def fullscreen = {
        def mapInstance = Map.get(params.id)
        if ((!mapInstance) || (!mapInstance.isPublic)) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
        else {
            [mapInstance: mapInstance]
        }
    }

   
    def show = {
        def mapInstance = Map.get(params.id)
        if ((!mapInstance) || (!mapInstance.isPublic)) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])}"
            redirect(action: "list")
        }
        else {
            [mapInstance: mapInstance]
        }
    }

}
