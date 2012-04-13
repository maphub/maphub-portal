# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Mime::Type.register "application/rdf+xml", :rdfxml

# How to implement a custom renderer:
#   http://www.glebm.com/2011/03/rendering-xslx-from-rails-3-without.html
#   http://www.engineyard.com/blog/2010/render-options-in-rails-3/

Mime::Type.register "application/turtle", :ttl

ActionController::Renderers.add :ttl do |ttl, options|
  self.content_type ||= Mime::TTL
  ttl.respond_to?(:to_ttl) ? ttl.to_ttl : ttl
end

