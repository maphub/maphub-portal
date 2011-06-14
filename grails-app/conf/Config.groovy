// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable for AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// set per-environment serverURL stem for creating absolute links
environments {
    production {
        grails.serverURL = "http://www.changeme.com"
    }
    development {
        grails.serverURL = "http://localhost:8080/${appName}"
    }
    test {
        grails.serverURL = "http://localhost:8080/${appName}"
    }

}

jquery {
    sources = 'jquery' // Holds the value where to store jQuery-js files /web-app/js/
    version = '1.5.2' // The jQuery version in use
}

// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console
    // appender:
    //
    //appenders {
  //      console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
  //  }

    warn  'org.codehaus.groovy.grails.web.servlet',  //  controllers
           'org.codehaus.groovy.grails.web.pages', //  GSP
           'org.codehaus.groovy.grails.web.sitemesh', //  layouts
           'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
           'org.codehaus.groovy.grails.web.mapping', // URL mapping
           'org.codehaus.groovy.grails.commons', // core / classloading
           'org.codehaus.groovy.grails.plugins', // plugins
           'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
           'org.springframework',
           'org.hibernate',
           'net.sf.ehcache.hibernate'

    warn   'org.mortbay.log'
    
    debug   'org.codehaus.groovy.grails.app.filter'
    
    
    // debug   'org.hibernate.SQL'
}


avatarPlugin {
	defaultGravatarUrl="http://localhost:8080/maphub-portal/images/avatar_large.png"
}

// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'at.ait.dme.maphub.User'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'at.ait.dme.maphub.UserRole'
grails.plugins.springsecurity.authority.className = 'at.ait.dme.maphub.Role'

grails.plugins.springsecurity.controllerAnnotations.staticRules = [
   '/user/search': ['ROLE_USER_RW', 'ROLE_USER_RO', 'ROLE_ADMIN'],
   '/user/**': ['ROLE_ADMIN'],
   '/role/**': ['ROLE_ADMIN'],
   '/registrationCode/**': ['ROLE_ADMIN'],
   '/persistentLogin/**': ['ROLE_ADMIN'],
   '/layout/**': ['ROLE_ADMIN'],
   '/aclObjectIdentity/**': ['ROLE_ADMIN'],
   '/aclSid/**': ['ROLE_ADMIN'],
   '/aclClass/**': ['ROLE_ADMIN'],
   '/aclEntry/**': ['ROLE_ADMIN'],
   '/registrationCode/**': ['ROLE_ADMIN'],
   '/securityInfo/**': ['ROLE_ADMIN']
]

grails.plugins.springsecurity.useSecurityEventListener = true

grails.plugins.springsecurity.onInteractiveAuthenticationSuccessEvent = { e, appCtx ->
    at.ait.dme.maphub.User.withTransaction {
          def user = at.ait.dme.maphub.User.get(appCtx.springSecurityService.principal.id)
          user.lastLoginDate = new Date()
          user.save(failOnError: true)
    }
}


