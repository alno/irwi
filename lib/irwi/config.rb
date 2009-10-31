class Irwi::Config
  
  attr_accessor_with_default :controller_name, 'wiki_pages'
  
  attr_accessor_with_default :user_class_name, 'User'
  
  attr_accessor_with_default :page_class_name, 'WikiPage'
  attr_accessor_with_default :page_version_class_name, 'WikiPageVersion'
  
  attr_accessor_with_default :page_version_foreign_key, 'page_id'
  
  # Object using to format content
  attr_accessor_with_default :formatter do
    Irwi::Formatters::RedCloth.new
  end
  
  # Object using to compare pages
  attr_accessor_with_default :comparator do
    Irwi::Comparators::DiffLcs.new
  end
  
  # Object using to paginate collections
  attr_accessor_with_default :paginator do
    Irwi::Paginators::None.new
  end
  
  def page_class
    page_class_name.constantize
  end
  
  def page_vrsion_class
    page_version_class_name.constantize
  end
  
  def user_class
    user_class_name.constantize
  end
  
end