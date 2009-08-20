class RiwikiGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      
      # Config files
      # m.file 'config/riwiki.yml', 'config/riwiki.yml'
        
      # Controllers
      m.file 'controllers/wiki_pages_controller.rb', 'app/controllers/wiki_pages_controller.rb'
        
      # Helpers
      m.file 'helpers/wiki_pages_helper.rb', 'app/helpers/wiki_pages_helper.rb'
      
      # Models
      m.file 'models/wiki_page.rb',         'app/models/wiki_page.rb'
      m.file 'models/wiki_page_version.rb', 'app/models/wiki_page_version.rb'
        
      # Migrations
      m.migration_template 'migrate/create_wiki_pages.rb', 'db/migrate', :migration_file_name => "create_wiki_pages"

      # Routes
      m.gsub_file 'config/routes.rb', /#{Regexp.quote 'ActionController::Routing::Routes.draw do |map|'}\n/, "\\0\n  map.riwiki_root '/wiki'\n"
    end
  end
end