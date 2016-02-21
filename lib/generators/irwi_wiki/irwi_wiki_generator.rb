require 'rails/generators/active_record'

class IrwiWikiGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path("../templates", __FILE__)

  def generate_wiki
    # Controllers
    copy_file 'controllers/wiki_pages_controller.rb', 'app/controllers/wiki_pages_controller.rb'

    # Helpers
    copy_file 'helpers/wiki_pages_helper.rb', 'app/helpers/wiki_pages_helper.rb'

    # Models
    copy_file 'models/wiki_page.rb',         'app/models/wiki_page.rb'
    copy_file 'models/wiki_page_version.rb', 'app/models/wiki_page_version.rb'

    # Migrations
    migration_template 'migrate/create_wiki_pages.rb', 'db/migrate/create_wiki_pages.rb'

    # Routes
    route "wiki_root '/wiki'"
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number dirname
  end
end
