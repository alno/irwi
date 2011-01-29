module Irwi::Extensions::Models::WikiPageAttachment

  DEFAULT_PAPERCLIP_OPTIONS = {:styles => { :medium => "300x300>", :thumb => "100x100>" }}

  def self.included( base )
    base.belongs_to :page, :class_name => Irwi.config.page_class_name
  end

end
