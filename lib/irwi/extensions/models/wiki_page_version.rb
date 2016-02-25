module Irwi::Extensions::Models::WikiPageVersion
  extend ActiveSupport::Concern

  def next
    self.class.first conditions: ["id > ? AND page_id = ?", id, page_id], order: 'id ASC'
  end

  def previous
    self.class.first conditions: ["id < ? AND page_id = ?", id, page_id], order: 'id DESC'
  end

  private

  def raise_on_update
    raise ActiveRecordError, "Can't modify existing version"
  end

  included do
    belongs_to :page, class_name: Irwi.config.page_class_name
    belongs_to :updator, class_name: Irwi.config.user_class_name

    before_update :raise_on_update

    scope :between, lambda { |first, last|
      first = first.to_i
      last = last.to_i
      first, last = last, first if last < first # Reordering if neeeded

      where('number >= ? AND number <= ?', first, last)
    }
  end
end
