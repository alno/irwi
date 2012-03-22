module Irwi::Extensions::Controllers::WikiPages

  module ClassMethods

    def page_class
      @page_class ||= Irwi.config.page_class
    end

    def set_page_class(arg)
      @page_class = arg
    end

  end

  module InstanceMethods

    include Irwi::Extensions::Controllers::WikiPageAttachments
    include Irwi::Support::TemplateFinder

    def show
      return not_allowed unless show_allowed?

      render_template( @page.new_record? ? 'no' : 'show' )
    end

    def history
      return not_allowed unless history_allowed?

      @versions = Irwi.config.paginator.paginate( @page.versions, :page => params[:page] ) # Paginating them

      render_template( @page.new_record? ? 'no' : 'history' )
    end

    def compare
      return not_allowed unless history_allowed?

      if @page.new_record?
        render_template 'no'
      else
        new_num = params[:new].to_i || @page.last_version_number # Last version number
        old_num = params[:old].to_i || 1 # First version number

        old_num, new_num = new_num, old_num if new_num < old_num # Swapping them if last < first

        versions = @page.versions.between( old_num, new_num ) # Loading all versions between first and last

        @versions = Irwi.config.paginator.paginate( versions, :page => params[:page] ) # Paginating them

        @new_version = @versions.first.number == new_num ? @versions.first : versions.first # Loading next version
        @old_version = @versions.last.number == old_num ? @versions.last : versions.last # Loading previous version

        render_template 'compare'
      end
    end

    def new
      return not_allowed unless show_allowed? && edit_allowed?

      render_template 'new'
    end

    def edit
      return not_allowed unless show_allowed? && edit_allowed?

      render_template 'edit'
    end

    def update
      return not_allowed unless params[:page] && (@page.new_record? || edit_allowed?) # Check for rights (but not for new record, for it we will use second check only)

      @page.attributes = params[:page] # Assign new attributes
      @page.comment = params[:page][:comment]

      return not_allowed unless edit_allowed? # Double check: used beacause action may become invalid after attributes update

      @page.updator = @current_user # Assing user, which updated page
      @page.creator = @current_user if @page.new_record? # Assign it's creator if it's new page

      if !params[:preview] && (params[:cancel] || @page.save)
        redirect_to url_for( :action => :show, :path => @page.path.split('/') ) # redirect to new page's path (if it changed)
      else
        render_template 'edit'
      end
    end

    def destroy
      return not_allowed unless destroy_allowed?

      @page.destroy

      redirect_to url_for( :action => :show )
    end

    def all
      @pages = Irwi.config.paginator.paginate( page_class, :page => params[:page] ) # Loading and paginating all pages

      render_template 'all'
    end

    protected

    # Retrieves wiki_page_class for this controller
    def page_class
      self.class.page_class
    end

    # Renders user-specified or default template
    def render_template( template )
      render "#{template_dir template}/#{template}", :status => (case template when 'no' then 404 when 'not_allowed' then 403 else 200 end)
    end

    # Initialize @current_user instance variable
    def setup_current_user
      @current_user = respond_to?( :current_user, true ) ? current_user : nil # Find user by current_user method or return nil
    end

    # Initialize @page instance variable
    def setup_page
      @page = page_class.find_by_path_or_new( params[:path] || '' ) # Find existing page by path or create new
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
      show_allowed?
    end

    # Check is it allowed for current user edit current page. Designed to be redefined by application programmer
    def edit_allowed?
      show_allowed?
    end

    # Check is it allowed for current user destroy current page. Designed to be redefined by application programmer
    def destroy_allowed?
      edit_allowed?
    end

  end

  def self.included( base )
    base.send :extend, Irwi::Extensions::Controllers::WikiPages::ClassMethods
    base.send :include, Irwi::Extensions::Controllers::WikiPages::InstanceMethods

    base.before_filter :setup_current_user # Setup @current_user instance variable before each action
    # Setup @page instance variable before each action
    base.before_filter :setup_page, :only => [ :show, :history, :compare, :new, :edit, :update, :destroy, :add_attachment ]
    base.helper_method :show_allowed?, :edit_allowed?, :history_allowed?, :destroy_allowed? # Access control methods are avaliable in views
  end

end
