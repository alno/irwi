require 'active_support/core_ext/hash'

class Irwi::Paginators::None
  def paginate(collection, _options = {})
    collection.all
  end

  def paginated_section(_view, _collection, &_block)
    yield
    nil
  end
end
