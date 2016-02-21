require 'rails/generators/active_record'

class IrwiWikiAttachmentsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration

  source_root File.expand_path("../templates", __FILE__)

  def generate_attachments
    %w(create_wiki_page_attachments).each do |mig|
      unless Dir.entries(File.join(Rails.root, 'db', 'migrate')).grep(/#{mig}/).present?
        migration_template "migrate/#{mig}.rb", "db/migrate/#{mig}.rb"
        sleep(1) # To avoid migration file version collision.
      end
    end

    # Models
    copy_file 'models/wiki_page_attachment.rb', 'app/models/wiki_page_attachment.rb'
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number dirname
  end
end
