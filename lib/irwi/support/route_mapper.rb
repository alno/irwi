module Irwi::Support::RouteMapper
  
  # Defining wiki root mount point
  def wiki_root( path, config = {} )
    opts = {
      :controller => 'wiki_pages',
      :root => path
    }.merge(config)
        
    connect( "#{path}/compare/*path", opts.merge({ :action => 'compare' }) ) # Comparing two versions of page
    connect( "#{path}/edit/*path", opts.merge({ :action => 'edit' }) ) # Wiki edit route
    connect( "#{path}/history/*path", opts.merge({ :action => 'history' }) ) # Wiki history route
    connect( "#{path}/*path", opts.merge({ :action => 'update', :conditions => { :method => :post } }) ) # Save wiki pages route
    connect( "#{path}/*path", opts.merge({ :action => 'show', :conditions => { :method => :get } }) ) # Wiki pages route
  end
  
end
