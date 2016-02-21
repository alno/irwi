class Irwi::Paginators::WillPaginate
  def initialize
    require 'will_paginate'
  end

  def paginate(collection, options = {})
    collection.paginate(options)
  end

  def paginated_section(view, collection, &block)
    view.paginated_section(collection, &block)
  end
end
