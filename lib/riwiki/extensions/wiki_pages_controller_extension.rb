module Riwiki::Extensions::WikiPagesControllerExtension
  
  module ClassMethods
    
    attr_reader :wiki_page_class
    
    def set_wiki_page_class(arg)
      @wiki_page_class = arg
    end
    
  end
  
  module InstanceMethods
    
    def show
      @page = wiki_page_class.find_by_path( @path )
      
      select_template 'show'
    end
    
    def edit
      @page = wiki_page_class.find_by_path_or_new( @path ) # Find existing page or create new
      
      select_template 'edit'
    end
    
    def update
      @page = wiki_page_class.find_by_path_or_new( @path ) # Find existing page or create new
      @page.attributes = params[:page] # Assign new attributes
      
      if @page.new_record? # If it's fresh page
        @page.path = @path # Assign it's path
      end
           
      if @page.save
        redirect_to url_for( :action => :show )
      else
        select_template 'edit'
      end
    end
    
    protected
    
    def wiki_page_class
      self.class.wiki_page_class
    end
    
    def select_template( template )
      dir = controller_path
      dir = 'base_wiki_pages' if Dir.glob( "app/views/#{dir}/#{template}.html.*" ).empty?
      
      render "#{dir}/#{template}"
    end
    
    def current_user
      nil
    end
    
    def setup_path
      @path = params[:path].join('/')
    end
    
  end

  def self.included( base )
    base.send :extend, Riwiki::Extensions::WikiPagesControllerExtension::ClassMethods
    base.send :include, Riwiki::Extensions::WikiPagesControllerExtension::InstanceMethods
    
    base.before_filter :setup_path # Setup @path instance variable before each action
    
  end
  
end