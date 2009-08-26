class Irwi::Config
  
  attr_accessor_with_default :user_class_name, 'User'
  
  attr_accessor_with_default :page_class_name, 'WikiPage'
  attr_accessor_with_default :page_version_class_name, 'WikiPageVersion'
  
  attr_accessor_with_default :page_version_foreign_key, 'page_id'
  
  def formatter
    @formatter ||= select_formatter
  end
  
  def formatter=(fmt)
    @formatter = fmt
  end
  
  private
  
  def select_formatter
    Irwi::Formatters::RedCloth.new
  end
  
end