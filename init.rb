require 'riwiki'

require 'riwiki/support/route_mapper' # Routes

ActionController::Routing::RouteSet::Mapper.instance_eval do
  include Riwiki::Support::RouteMapper
end

ActiveRecord::Base.instance_eval do
  
  def acts_as_wiki_page
    include Riwiki::Extensions::WikiPageModelExtension
  end
  
end

ActionController::Base.instance_eval do
  
  def acts_as_wiki_pages_controller
    include Riwiki::Extensions::WikiPagesControllerExtension
  end
  
end