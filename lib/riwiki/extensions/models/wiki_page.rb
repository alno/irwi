module Riwiki::Extensions::Models::WikiPage
  
  module ClassMethods
    
    def find_by_path_or_new( path )
      self.find_by_path( path ) || self.new( :path => path )
    end
    
  end
  
  module InstanceMethods
    
    protected
        
    def create_new_version
      v = versions.build
      v.attributes = self.attributes.slice( v.attribute_names )
      v.save!
    end
    
  end
  
  def self.included( base )
    base.send :extend, Riwiki::Extensions::Models::WikiPage::ClassMethods
    base.send :include, Riwiki::Extensions::Models::WikiPage::InstanceMethods
    
    base.send :attr_accessor, :comment
    
    base.belongs_to :creator, :class_name => Riwiki.config.user_class_name
    base.belongs_to :updator, :class_name => Riwiki.config.user_class_name
    
    base.has_many :versions, :class_name => Riwiki.config.page_version_class_name, :foreign_key => Riwiki.config.page_version_foreign_key, :order => 'created_at DESC'
    
    base.after_save :create_new_version
  end
  
end