class Irwi::Formatters::RedCloth

  def initialize
    require 'redcloth'
  end

  def format( text )
    ::RedCloth.new( text ).to_html
  end

end
