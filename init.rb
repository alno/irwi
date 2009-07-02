require 'riwiki'

require 'riwiki/support/route_mapper' # Routes

ActionController::Routing::RouteSet::Mapper.instance_eval do
  include Riwiki::Support::RouteMapper
end