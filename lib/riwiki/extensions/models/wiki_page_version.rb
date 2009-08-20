module Riwiki::Extensions::Models::WikiPageVersion
  
  module ClassMethods
        
  end
  
  module InstanceMethods
    
  end
  
  def self.included( base )
    base.send :extend, Riwiki::Extensions::Models::WikiPageVersion::ClassMethods
    base.send :include, Riwiki::Extensions::Models::WikiPageVersion::InstanceMethods
    
    #base.belongs_to :creator, :class_name => Riwiki.options.user_class_name
    #base.belongs_to :updator, :class_name => Riwiki.options.user_class_name
  end
  
end