# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Mime::Type.register "application/rdf+xml", :rdf
ActionController::Renderers.add :rdf do |obj, options|
  obj.respond_to?(:to_rdf) ? obj.to_rdf(:rdfxml, options) : obj
end

Mime::Type.register "text/turtle", :ttl
ActionController::Renderers.add :ttl do |obj, options|
  obj.respond_to?(:to_rdf) ? obj.to_rdf(:ttl, options) : obj
end

Mime::Type.register "text/plain", :nt
ActionController::Renderers.add :nt do |obj, options|
  obj.respond_to?(:to_rdf) ? obj.to_rdf(:ntriples, options) : obj
end

Mime::Type.register "application/vnd.google-earth.kml+xml", :kml