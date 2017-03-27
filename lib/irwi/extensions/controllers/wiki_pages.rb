module Irwi::Extensions::Controllers::WikiPages
  extend ActiveSupport::Concern

  module ClassMethods
    def page_class
      @page_class ||= Irwi.config.page_class
    end

    def set_page_class(arg)
      @page_class = arg
    end
  end

  include Irwi::Extensions::Controllers::WikiPageAttachments
  include Irwi::Support::TemplateFinder

  def show
    return not_allowed unless show_allowed?

    render_template(@page.new_record? ? 'no' : 'show')
  end

  def history
    return not_allowed unless history_allowed?

    @versions = Irwi.config.paginator.paginate(@page.versions, page: params[:page]) # Paginating them

    render_template(@page.new_record? ? 'no' : 'history')
  end

  def compare
    return not_allowed unless history_allowed?

    if @page.new_record?
      render_template 'no'
    else
      @versions, @old_version, @new_version = load_paginated_versions(*version_number_params)

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

    @page.attributes = permitted_page_params

    return not_allowed unless edit_allowed? # Double check: used beacause action may become invalid after attributes update

    @page.updator = @current_user # Assing user, which updated page
    @page.creator = @current_user if @page.new_record? # Assign it's creator if it's new page

    if !params[:preview] && (params[:cancel] || @page.save)
      redirect_to url_for(action: :show, path: @page.path.split('/')) # redirect to new page's path (if it changed)
    else
      render_template 'edit'
    end
  end

  def destroy
    return not_allowed unless destroy_allowed?

    @page.destroy

    redirect_to url_for(action: :show)
  end

  def all
    @pages = Irwi.config.paginator.paginate(page_class, page: params[:page]) # Loading and paginating all pages

    render_template 'all'
  end

  private

  def load_paginated_versions(old_num, new_num)
    versions = @page.versions.between(old_num, new_num) # Loading all versions between first and last

    paginated_versions = Irwi.config.paginator.paginate(versions, page: params[:page]) # Paginating them

    new_version = paginated_versions.first.number == new_num ? paginated_versions.first : versions.first # Load next version
    old_version = paginated_versions.last.number == old_num ? paginated_versions.last : versions.last # Load previous version

    [paginated_versions, old_version, new_version]
  end

  def version_number_params
    new_num = params[:new].to_i || @page.last_version_number # Last version number
    old_num = params[:old].to_i || 1 # First version number

    if new_num < old_num # Swapping them if last < first
      [new_num, old_num]
    else
      [old_num, new_num]
    end
  end

  def permitted_page_params
    params.require(:page).permit(:title, :content, :comment, :previous_version_number)
  end

  # Retrieves wiki_page_class for this controller
  def page_class
    self.class.page_class
  end

  # Renders user-specified or default template
  def render_template(template)
    render "#{template_dir template}/#{template}", status: select_template_status(template)
  end

  def select_template_status(template)
    case template
    when 'no' then 404
    when 'not_allowed' then 403
    else 200
    end
  end

  # Initialize @current_user instance variable
  def setup_current_user
    @current_user = respond_to?(:current_user, true) ? current_user : nil # Find user by current_user method or return nil
  end

  # Initialize @page instance variable
  def setup_page
    @page = page_class.find_by_path_or_new(params[:path] || '') # Find existing page by path or create new
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

  included do
    before_action :setup_current_user # Setup @current_user instance variable before each action

    # Setup @page instance variable before each action
    before_action :setup_page, only: [:show, :history, :compare, :new, :edit, :update, :destroy, :add_attachment]
    helper_method :show_allowed?, :edit_allowed?, :history_allowed?, :destroy_allowed? # Access control methods are avaliable in views
  end
end
