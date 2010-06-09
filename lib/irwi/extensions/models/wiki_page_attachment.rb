module Irwi::Extensions::Models::WikiPageAttachment
  
  DEFAULT_PAPERCLIP_OPTIONS = {:styles => { :medium => "300x300>", :thumb => "100x100>" }}
  
  module ClassMethods    
    def paperclip_options= options
      send :has_attached_file, :wiki_page_attachment, options || DEFAULT_PAPERCLIP_OPTIONS
    end
  end
  
  module InstanceMethods    
  end
  
  def self.included( base )
    base.send :extend, Irwi::Extensions::Models::WikiPageAttachment::ClassMethods
    base.send :include, Irwi::Extensions::Models::WikiPageAttachment::InstanceMethods
  
    base.belongs_to :page, :class_name => Irwi.config.page_class_name
  end
  
end