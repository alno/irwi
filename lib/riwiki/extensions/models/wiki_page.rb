module Riwiki::Extensions::Models::WikiPage
  
  module ClassMethods
    
    def find_by_path_or_new( path )
      self.find_by_path( path ) || self.new( :path => path )
    end
    
  end
  
  module InstanceMethods
    
  end
  
  def self.included( base )
    base.send :extend, Riwiki::Extensions::Models::WikiPage::ClassMethods
    base.send :include, Riwiki::Extensions::Models::WikiPage::InstanceMethods
    
    base.belongs_to :creator, :class_name => Riwiki.options.user_class_name
    base.belongs_to :updator, :class_name => Riwiki.options.user_class_name
  end
  
end