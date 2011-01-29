require 'active_record'

module Irwi::Extensions::Models
  autoload :WikiPage, 'irwi/extensions/models/wiki_page'
  autoload :WikiPageVersion, 'irwi/extensions/models/wiki_page_version'
  autoload :WikiPageAttachment, 'irwi/extensions/models/wiki_page_attachment'
end

ActiveRecord::Base.instance_eval do

  def acts_as_wiki_page( config = {} )
    include Irwi::Extensions::Models::WikiPage
  end

  def acts_as_wiki_page_version( config = {} )
    include Irwi::Extensions::Models::WikiPageVersion
  end

  def acts_as_wiki_page_attachment
    include Irwi::Extensions::Models::WikiPageAttachment
    yield if block_given?
  end

end
