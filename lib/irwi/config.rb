class Irwi::Config
  
  attr_accessor_with_default :user_class_name, 'User'
  
  attr_accessor_with_default :page_class_name, 'WikiPage'
  attr_accessor_with_default :page_version_class_name, 'WikiPageVersion'
  
  attr_accessor_with_default :page_version_foreign_key, 'page_id'
  
  attr_accessor_with_default :formatter do
    Irwi::Formatters::RedCloth.new
  end
  
  attr_accessor_with_default :comparator do
    Irwi::Comparators::DiffLcs.new
  end
  
end