require 'active_support/core_ext/hash'

class Irwi::Paginators::None

  def paginate( collection, options = {} )
    find_options = options.except :page, :per_page, :total_entries, :finder

    collection.find( :all, find_options )
  end

  def paginated_section( view, collection, &block )
    yield
    return
  end

end
