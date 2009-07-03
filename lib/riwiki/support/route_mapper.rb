module Riwiki::Support::RouteMapper
  
  # Defining wiki root mount point
  def riwiki_root( path, options = {} )
    opts = {
      :controller => 'riwiki/base_pages',
      :root => path
    }.merge(options)
        
    connect( "#{path}/edit/*page", opts.merge({ :action => 'edit' }) ) # Wiki edit route
    connect( "#{path}/*page", opts.merge({ :action => 'update', :method => :post }) ) # Save wiki pages route
    connect( "#{path}/*page", opts.merge({ :action => 'show', :method => :get }) ) # Wiki pages route
  end
  
end
