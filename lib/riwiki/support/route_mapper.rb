module Riwiki::Support::RouteMapper
  
  # Defining wiki root mount point
  def riwiki_root( path, options = {} )
    opts = {
    }.merge(options)
    
    opts[:controller] = 'riwiki/base_pages'
    opts[:action] = 'show'
    
    connect( "#{path}/*page", opts ) # Mounting wiki root
  end
  
end
