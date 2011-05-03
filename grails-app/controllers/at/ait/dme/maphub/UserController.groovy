package at.ait.dme.maphub

class UserController extends grails.plugins.springsecurity.ui.UserController {
  
  def browse = {
        params.max = Math.min(params?.max?.toInteger() ?: 20, 200)
        params.offset = params?.offset?.toInteger() ?: 0
        params.sort = params?.sort ?: "reputation"
        params.order = params?.order ?: "desc"
        
        def users = User.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {}
        
        params.totalUsers = users.totalCount
        [ userInstanceList : users, userInstanceTotal : users.totalCount, params: params ]
  }
  
}
