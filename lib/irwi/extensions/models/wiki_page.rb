module Irwi::Extensions::Models::WikiPage
  extend ActiveSupport::Concern

  module ClassMethods
    def find_by_path_or_new(path)
      find_by_path(path) || new(path: path, title: CGI.unescape(path))
    end
  end

  # Retrieve number of last version
  def last_version_number
    last = versions.first
    last ? last.number : 0
  end

  protected

  def create_new_version
    n = last_version_number

    v = versions.build
    v.attributes = attributes.slice(*(v.attribute_names - ['id']))
    v.comment = comment
    v.number = n + 1
    v.save!
  end

  included do
    attr_accessor :comment, :previous_version_number

    belongs_to :creator, class_name: Irwi.config.user_class_name
    belongs_to :updator, class_name: Irwi.config.user_class_name

    has_many :versions, -> { order('id DESC') }, class_name: Irwi.config.page_version_class_name, foreign_key: Irwi.config.page_version_foreign_key

    if Irwi.config.page_attachment_class_name
      has_many :attachments, class_name: Irwi.config.page_attachment_class_name, foreign_key: Irwi.config.page_version_foreign_key
    end

    before_save { |record| record.content = '' if record.content.nil? }
    after_save :create_new_version
  end
end
