# determines which files to reload in development mode
# http://hemju.com/2011/02/11/rails-3-quicktip-auto-reload-lib-folders-in-development-mode/

RELOAD_LIBS = Dir[Rails.root + 'lib/**/*.rb'] if Rails.env.development?