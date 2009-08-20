require 'riwiki'

require 'riwiki/support/route_mapper' # Routes

ActionController::Routing::RouteSet::Mapper.instance_eval do
  include Riwiki::Support::RouteMapper
end

ActiveRecord::Base.instance_eval do
  
  # 
  def acts_as_wiki_page( options = {} )
    include Riwiki::Extensions::Models::WikiPage
  end
  
  # 
  def acts_as_wiki_page_version( options = {} )
    include Riwiki::Extensions::Models::WikiPageVersion
  end
  
end

ActionController::Base.instance_eval do
  
  # @param options [Hash] options for controller class
  # @option page_class
  #
  def acts_as_wiki_pages_controller( options = {} )
    include Riwiki::Extensions::Controllers::WikiPages
    
    set_page_class options[:page_class] || 'WikiPage'.constantize # Setting wiki page class
  end
  
end