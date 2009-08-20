module Riwiki::Extensions::Controllers::WikiPages
  
  module ClassMethods
    
    def page_class
      @page_class ||= Riwiki.config.page_class_name.constantize
    end
    
    def set_page_class(arg)
      @page_class = arg
    end
    
  end
  
  module InstanceMethods
    
    include Riwiki::Support::TemplateFinder
    
    def show      
      render_template 'show'
    end
    
    def edit      
      render_template 'edit'
    end
    
    def update      
      @page.attributes = params[:page] # Assign new attributes
        
      @page.updator = @current_user # Assing user, which updated page
      @page.creator = @current_user if @page.new_record? # Assign it's creator if it's new page
           
      if @page.save
        redirect_to url_for( :action => :show, :path => @page.path.split('/') ) # redirect to new page's path (if it changed)
      else
        render_template 'edit'
      end
    end
    
    protected
    
    # Retrieves wiki_page_class for this controller
    def page_class
      self.class.page_class
    end
    
    # Renders user-specified or default template
    def render_template( template )
      render "#{template_dir template}/#{template}"
    end
    
    # Initialize @current_user instance variable
    def setup_current_user
      @current_user = respond_to?( :current_user ) ? current_user : nil # Find user by current_user method or return nil
    end
    
    # Initialize @page instance variable
    def setup_page
      @page = page_class.find_by_path_or_new( params[:path].join('/') ) # Find existing page by path or create new
    end
    
  end

  def self.included( base )
    base.send :extend, Riwiki::Extensions::Controllers::WikiPages::ClassMethods
    base.send :include, Riwiki::Extensions::Controllers::WikiPages::InstanceMethods
    
    base.before_filter :setup_current_user # Setup @current_user instance variable before each action    
    base.before_filter :setup_page # Setup @page instance variable before each action
  end
  
end