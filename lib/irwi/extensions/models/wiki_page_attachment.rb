module Irwi::Extensions::Models::WikiPageAttachment
  
  
  module InstanceMethods
    
    # define instance methods here.
    
  end
  
  def self.included( base )
    base.send :include, Irwi::Extensions::Models::WikiPage::InstanceMethods
    
    base.send :has_attached_file, :wiki_page_attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    
    base.belongs_to :page, :class_name => Irwi.config.page_class_name
  end
  
end