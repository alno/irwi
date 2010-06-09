require 'paperclip'

class WikiPageAttachment < ActiveRecord::Base
  acts_as_wiki_page_attachment
end