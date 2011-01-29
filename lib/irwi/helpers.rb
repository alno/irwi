module Irwi::Helpers

end

Module.class_eval do

  def acts_as_wiki_pages_helper( config = {} )
    include Irwi::Helpers::WikiPagesHelper
    include Irwi::Helpers::WikiPageAttachmentsHelper if Irwi::config.page_attachment_class_name
  end

end
