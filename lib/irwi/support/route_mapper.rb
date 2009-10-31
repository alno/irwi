module Irwi::Support::RouteMapper
  
  # Defining wiki root mount point
  def wiki_root( path, config = {} )
    opts = {
      :controller => 'wiki_pages',
      :root => path
    }.merge(config)
    
    Irwi.config.system_pages.each do |page_action, page_path| # Adding routes for system pages
      connect( "#{path}/#{page_path}", opts.merge({ :action => page_action }) )
    end
        
    connect( "#{path}/compare/*path", opts.merge({ :action => 'compare' }) ) # Comparing two versions of page
    connect( "#{path}/edit/*path", opts.merge({ :action => 'edit' }) ) # Wiki edit route
    connect( "#{path}/history/*path", opts.merge({ :action => 'history' }) ) # Wiki history route
    
    connect( "#{path}/*path", opts.merge({ :action => 'destroy', :conditions => { :method => :delete } }) ) # Wiki destroy route
    connect( "#{path}/*path", opts.merge({ :action => 'update', :conditions => { :method => :post } }) ) # Save wiki pages route
    connect( "#{path}/*path", opts.merge({ :action => 'show', :conditions => { :method => :get } }) ) # Wiki pages route
  end
  
end
