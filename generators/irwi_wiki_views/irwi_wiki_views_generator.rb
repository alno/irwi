class IrwiWikiViewsGenerator < Rails::Generator::Base
  
  def initialize(runtime_args, runtime_options = {})
    super( runtime_args, runtime_options )
    
    @source_root = options[:source] || File.join(spec.path, '..', '..', 'app', 'views', 'base_wiki_pages')
  end
  
  def manifest    
    record do |m|      
      m.directory 'app/views/base_wiki_pages'
    
      Dir.foreach source_root do |file| # Searching for files in app/views
        m.file( file, 'app/views/base_wiki_pages/' + file ) if file != '.' && file != '..'
      end
    end
    
  end
end