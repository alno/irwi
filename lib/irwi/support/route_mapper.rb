module Irwi::Support::RouteMapper
  
  # Defining wiki root mount point
  def wiki_root( root, config = {} )
    opts = {
      :controller => 'wiki_pages',
      :root => root
    }.merge(config)
    
    Irwi.config.system_pages.each do |page_action, page_path| # Adding routes for system pages
      connect( "#{root}/#{page_path}", opts.merge({ :action => page_action }) )
    end
        
    connect( "#{root}/compare/*path", opts.merge({ :action => 'compare' }) ) # Comparing two versions of page
    connect( "#{root}/new/*path", opts.merge({ :action => 'new' }) ) # Wiki new route
    connect( "#{root}/edit/*path", opts.merge({ :action => 'edit' }) ) # Wiki edit route
    connect( "#{root}/history/*path", opts.merge({ :action => 'history' }) ) # Wiki history route
    
    # Attachments
    connect("#{root}/attach/*path", opts.merge({:action => 'add_attachment', :conditions => {:method => :post}}))
    connect("#{root}/attach/delete/:attachment_id", opts.merge({:action => 'remove_attachment'}))
    
    
    connect( "#{root}/*path", opts.merge({ :action => 'destroy', :conditions => { :method => :delete } }) ) # Wiki destroy route
    connect( "#{root}/*path", opts.merge({ :action => 'update', :conditions => { :method => :post } }) ) # Save wiki pages route
    connect( "#{root}/*path", opts.merge({ :action => 'show', :conditions => { :method => :get } }) ) # Wiki pages route
  end
  
end
