class Riwiki::Formatters::BlueCloth
  
  def initialize
    require 'bluecloth'
  end
  
  def format( text )
    BlueCloth.new( text ).to_html
  end
  
end