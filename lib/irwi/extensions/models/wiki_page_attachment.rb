module Irwi::Extensions::Models::WikiPageAttachment
  extend ActiveSupport::Concern

  DEFAULT_PAPERCLIP_OPTIONS = { styles: { medium: "300x300>", thumb: "100x100>" } }.freeze

  included do
    belongs_to :page, class_name: Irwi.config.page_class_name
  end
end
