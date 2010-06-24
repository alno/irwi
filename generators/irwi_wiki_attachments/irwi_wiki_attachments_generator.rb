class IrwiWikiAttachmentsGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      %w[create_wiki_page_attachments].each do |mig|
        unless Dir.entries(File.join(Rails.root,'db','migrate')).grep(/#{mig}/).present?
          puts "Copying migration #{mig}"
          m.migration_template "migrate/#{mig}.rb", 'db/migrate', :migration_file_name => mig
          sleep(1) # To avoid migration file version collision.
        end
      end
      
      # Models
      m.file 'models/wiki_page_attachment.rb', 'app/models/wiki_page_attachment.rb'
    end
  end
  
end
