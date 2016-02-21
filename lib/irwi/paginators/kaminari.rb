class Irwi::Paginators::Kaminari
  def initialize
    require 'kaminari'
  end

  def paginate(collection, options = {})
    collection.page(options[:page])
  end

  def paginated_section(view, collection, &block)
    pager = view.paginate(collection)

    pager + view.capture(&block) + pager
  end
end
