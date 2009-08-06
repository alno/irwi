class RiwikiGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      
      # Config files
      # m.file 'config/riwiki.yml', 'config/riwiki.yml'
        
      # Controllers
      m.file 'controllers/wiki_pages_controller.rb', 'app/controllers/wiki_pages_controller.rb'
      
      # Models
      m.file 'models/wiki_page.rb', 'app/models/wiki_page.rb'
        
      # Migrations
      m.migration_template 'migrate/create_wiki_pages.rb', 'db/migrate', :migration_file_name => "create_wiki_pages"

    end
  end
end