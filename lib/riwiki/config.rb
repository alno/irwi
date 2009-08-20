class Riwiki::Config
  
  def self.string_attr_accessor(name,default)
    src = <<-END
      def #{name}
        @#{name} ||= '#{default}'
      end
      
      def #{name}=(v)
        @#{name} = v.to_s
      end
    END
    
    class_eval src, __FILE__, __LINE__
  end
  
  string_attr_accessor :user_class_name, 'User'
  
  string_attr_accessor :page_class_name, 'WikiPage'
  string_attr_accessor :page_version_class_name, 'WikiPageVersion'
  
  string_attr_accessor :page_version_foreign_key, 'page_id'
  
  def formatter
    @formatter ||= select_formatter
  end
  
  def formatter=(fmt)
    @formatter = fmt
  end
  
  private
  
  def select_formatter
    Riwiki::Formatters::RedCloth.new
  end
  
end