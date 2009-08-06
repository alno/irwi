module Riwiki::Extensions::WikiPageModelExtension
  
  module ClassMethods
    
    def find_by_path_or_new( path )
      self.find_by_path( path ) || self.new
    end
    
  end
  
  module InstanceMethods
    
  end
  
  def self.included( base )
    base.send :extend, Riwiki::Extensions::WikiPageModelExtension::ClassMethods
    base.send :include, Riwiki::Extensions::WikiPageModelExtension::InstanceMethods
  end
  
end