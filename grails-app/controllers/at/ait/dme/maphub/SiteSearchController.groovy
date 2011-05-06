package at.ait.dme.maphub

import org.compass.core.engine.SearchEngineQueryParseException

class SiteSearchController {

		def searchableService

    def index = {
			if (!params.q?.trim()) {
				return [:]
			}

			try {
				return [searchResult: searchableService.search(params.q, params)]
			} catch (SearchEngineQueryParseException ex) {
				return [parseException: true]
			}
	}
}
