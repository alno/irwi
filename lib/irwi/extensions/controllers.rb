require 'action_controller'

module Irwi::Extensions::Controllers
  autoload :WikiPages, 'irwi/extensions/controllers/wiki_pages'
  autoload :WikiPageAttachments, 'irwi/extensions/controllers/wiki_page_attachments'
end

ActionController::Base.instance_eval do

  # @param config [Hash] config for controller class
  # @option page_class
  #
  def acts_as_wiki_pages_controller( config = {} )
    include Irwi::Extensions::Controllers::WikiPages
    include Irwi::Extensions::Controllers::WikiPageAttachments if Irwi::config.page_attachment_class_name
  end

end
