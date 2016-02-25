require 'active_record/errors'

module Irwi::Helpers::WikiPageAttachmentsHelper
  def wiki_add_page_attachment_path(page)
    page = page.path if page.respond_to? :path
    url_for(action: 'add_attachment', path: page)
  end

  def wiki_remove_page_attachment_path(attachment_id)
    url_for(action: 'remove_attachment', attachment_id: attachment_id)
  end

  IRWI_ATTACHMENT_REGEXP = /Attachment_([\d]+)_([\w]+)/

  def wiki_show_attachments(str)
    str.gsub IRWI_ATTACHMENT_REGEXP do |_m|
      begin
        attachment = Irwi.config.page_attachment_class.find(Regexp.last_match(1))
        image_tag attachment.wiki_page_attachment.url(Regexp.last_match(2).to_sym), class: 'wiki_page_attachment'
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
