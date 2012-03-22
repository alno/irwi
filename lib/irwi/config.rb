require 'active_support'

class Irwi::Config

  attr_accessor :controller_name
  attr_accessor :user_class_name
  attr_accessor :page_class_name
  attr_accessor :page_version_class_name
  attr_accessor :page_attachment_class_name
  attr_accessor :page_version_foreign_key

  # Object using to format content
  attr_writer :formatter

  def formatter
    @formatter ||= begin
                     require 'irwi/formatters/red_cloth'
                     
                     self.formatter = Irwi::Formatters::RedCloth.new
                   end	
  end

  # Object using to compare pages
  attr_writer :comparator
  
  def comparator
    @comparator ||= begin
                      require 'irwi/comparators/diff_lcs'
                      
                      self.comparator = Irwi::Comparators::DiffLcs.new
                    end	
  end

  # Object using to paginate collections
  attr_writer :paginator
    
  def paginator
    @paginator ||= begin
                     require 'irwi/paginators/none'
                     
                     self.paginator = Irwi::Paginators::None.new
                   end	
  end

  def initialize
    @controller_name = 'wiki_pages'
    @user_class_name = 'User'
    @page_class_name = 'WikiPage'
    @page_version_class_name = 'WikiPageVersion'
    @page_attachment_class_name = nil
    @page_version_foreign_key = 'page_id'
  end   

  def page_class
    page_class_name.constantize
  end

  def page_version_class
    page_version_class_name.constantize
  end

  def page_attachment_class
    page_attachment_class_name.constantize
  end

  def user_class
    user_class_name.constantize
  end

  def system_pages
    @system_pages ||= {
      'all' => 'all'
    }
  end

  # Add system page
  # @param action [String,Symbol] controller action
  # @param path [String] path in routes
  def add_system_page( action, path )
    system_pages[ action.to_s ] = path.to_s
  end

end
