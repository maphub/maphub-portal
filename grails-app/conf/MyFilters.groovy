class MyFilters {

  private static final log = org.apache.commons.logging.LogFactory.getLog(this)

  def filters = {
    paramLogger(controller:'*', action:'*') {
      before = {
        log.debug "request params: $params"
      }
    }
  }
} 