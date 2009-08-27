module Irwi::Extensions::Controllers::WikiPages
  
  module ClassMethods
    
    def page_class
      @page_class ||= Irwi.config.page_class_name.constantize
    end
    
    def set_page_class(arg)
      @page_class = arg
    end
    
  end
  
  module InstanceMethods
    
    include Irwi::Support::TemplateFinder
    
    def show
      return not_allowed unless show_allowed?
      
      render_template( @page.new_record? ? 'no' : 'show' )
    end
    
    def history
      return not_allowed unless show_allowed? && history_allowed?
      
      render_template( @page.new_record? ? 'no' : 'history' )
    end
    
    def compare
      return not_allowed unless show_allowed? && history_allowed?
      
      if @page.new_record?
        render_template 'no'
      else
        @versions = @page.versions.between( params[:old] || 1, params[:new] || @page.last_version_number ).all # Loading all versions between first and last
        
        @new_version = @versions.last # Loading next version
        @old_version = @versions.first # Loading previous version
        
        render_template 'compare'
      end
    end
    
    def edit
      return not_allowed unless show_allowed? && edit_allowed?
      
      render_template 'edit'
    end
    
    def update
      return not_allowed unless @page.new_record? || ( show_allowed? && edit_allowed? ) # Check for rights (but not for new record, for it we will use second check only)
      
      @page.attributes = params[:page] # Assign new attributes
      
      return not_allowed unless show_allowed? && edit_allowed? # Double check: used beacause action may become invalid after attributes update
        
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
    
    # Method, which called when user tries to visit 
    def not_allowed
      render_template 'not_allowed'
    end
    
    # Check is it allowed for current user to see current page. Designed to be redefined by application programmer
    def show_allowed? 
      true
    end

    # Check is it allowed for current user see current page history. Designed to be redefined by application programmer
    def history_allowed?
      true
    end
    
    # Check is it allowed for current user edit current page. Designed to be redefined by application programmer
    def edit_allowed?
      true
    end
    
  end

  def self.included( base )
    base.send :extend, Irwi::Extensions::Controllers::WikiPages::ClassMethods
    base.send :include, Irwi::Extensions::Controllers::WikiPages::InstanceMethods
    
    base.before_filter :setup_current_user # Setup @current_user instance variable before each action    
    base.before_filter :setup_page # Setup @page instance variable before each action
    
    base.helper_method :show_allowed?, :edit_allowed?, :history_allowed? # Access control methods are avaliable in views
  end
  
end