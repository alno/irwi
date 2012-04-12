require 'action_dispatch'

module Irwi::Support::RouteMapper

  # Defining wiki root mount point
  def wiki_root( root, config = {} )
    opts = {
      :controller => 'wiki_pages',
      :root => root
    }.merge(config)

    Irwi.config.system_pages.each do |page_action, page_path| # Adding routes for system pages
      get( "#{root}/#{page_path}", opts.merge({ :action => page_action.dup }) )
    end

    get( "#{root}/compare/(*path)", opts.merge({ :action => 'compare', :as => 'compare_wiki_page' }) ) # Comparing two versions of page
    get( "#{root}/new/(*path)", opts.merge({ :action => 'new', :as => 'new_wiki_page' }) ) # Wiki new route
    get( "#{root}/edit/(*path)", opts.merge({ :action => 'edit', :as => 'edit_wiki_page' }) ) # Wiki edit route
    get( "#{root}/history/(*path)", opts.merge({ :action => 'history', :as => 'history_wiki_page' }) ) # Wiki history route

    # Attachments
    post("#{root}/attach/(*path)", opts.merge({:action => 'add_attachment' }))
    delete("#{root}/attach/:attachment_id", opts.merge({:action => 'remove_attachment' }))

    delete( "#{root}/(*path)", opts.merge({ :action => 'destroy', :as => 'destroy_wiki_page' }) ) # Wiki destroy route
    post( "#{root}/(*path)", opts.merge({ :action => 'update', :as => 'update_wiki_page' }) ) # Save wiki pages route
    get( "#{root}/(*path)", opts.merge({ :action => 'show', :as => 'wiki_page' }) ) # Wiki pages route
  end

end

ActionDispatch::Routing::Mapper.instance_eval do
  include Irwi::Support::RouteMapper
end
