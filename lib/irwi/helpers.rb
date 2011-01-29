module Irwi::Helpers
  autoload :WikiPagesHelper, 'irwi/helpers/wiki_pages_helper'
  autoload :WikiPageAttachmentsHelper, 'irwi/helpers/wiki_page_attachments_helper'
end

Module.class_eval do

  def acts_as_wiki_pages_helper( config = {} )
    include Irwi::Helpers::WikiPagesHelper
    include Irwi::Helpers::WikiPageAttachmentsHelper if Irwi::config.page_attachment_class_name
  end

end
