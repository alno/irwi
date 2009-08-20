class Riwiki::Config

  def self.class_name_attr_accessor(name,default)
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
  
  class_name_attr_accessor :user_class_name, 'User'
  
  class_name_attr_accessor :page_class_name, 'WikiPage'
  class_name_attr_accessor :page_version_class_name, 'WikiPageVersion'
  
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