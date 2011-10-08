class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # reloads libs in lib folder before each request (in development mode only)
  # http://hemju.com/2011/02/11/rails-3-quicktip-auto-reload-lib-folders-in-development-mode/
  before_filter :_reload_libs, :if => :_reload_libs?

  def _reload_libs
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?
    defined? RELOAD_LIBS
  end
  
end
