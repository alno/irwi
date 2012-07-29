class Irwi::Formatters::WikiCloth

  def initialize
    require 'wikicloth'
  end

  def format( text )
    WikiCloth::Parser.new({:data => text}).to_html
  end

end
