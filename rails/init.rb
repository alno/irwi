require 'irwi' # Main irwi class
require 'irwi/support/route_mapper' # Routes

ActionController::Routing::RouteSet::Mapper.instance_eval do
  include Irwi::Support::RouteMapper
end

ActiveRecord::Base.instance_eval do
  
  # 
  def acts_as_wiki_page( config = {} )
    include Irwi::Extensions::Models::WikiPage
  end
  
  # 
  def acts_as_wiki_page_version( config = {} )
    include Irwi::Extensions::Models::WikiPageVersion
  end
  
  def acts_as_wiki_page_attachment(config = {})
    include Irwi::Extensions::Models::WikiPageAttachment
  end
  
end

ActionController::Base.instance_eval do
  
  # @param config [Hash] config for controller class
  # @option page_class
  #
  def acts_as_wiki_pages_controller( config = {} )
    include Irwi::Extensions::Controllers::WikiPages
  end
  
end