module Irwi::Extensions::Models::WikiPageVersion

  module ClassMethods

  end

  module InstanceMethods

    def next
      self.class.first :conditions => ["id > ? AND page_id = ?", id, page_id], :order => 'id ASC'
    end

    def previous
      self.class.first :conditions => ["id < ? AND page_id = ?", id, page_id], :order => 'id DESC'
    end

    protected

    def raise_on_update
      raise ActiveRecordError.new "Can't modify existing version"
    end

  end

  def self.included( base )
    base.send :extend, Irwi::Extensions::Models::WikiPageVersion::ClassMethods
    base.send :include, Irwi::Extensions::Models::WikiPageVersion::InstanceMethods

    base.attr_protected :id

    base.belongs_to :page, :class_name => Irwi.config.page_class_name
    base.belongs_to :updator, :class_name => Irwi.config.user_class_name

    base.before_update :raise_on_update

    base.scope :between, lambda { | first, last |
      first = first.to_i
      last = last.to_i
      first, last = last, first if last < first # Reordering if neeeded
      { :conditions => [ 'number >= ? AND number <= ?', first, last ] }
    }
  end

end
