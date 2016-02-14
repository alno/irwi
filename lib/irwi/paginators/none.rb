require 'active_support/core_ext/hash'

class Irwi::Paginators::None

  def paginate( collection, options = {} )
    collection.all
  end

  def paginated_section( view, collection, &block )
    yield
    return
  end

end
