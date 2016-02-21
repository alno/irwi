class Irwi::Formatters::RedCarpet
  def initialize
    require 'redcarpet'
  end

  def format(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true, tables: true)
    markdown.render(text)
  end
end
