class Irwi::Formatters::SimpleHtml

  def initialize
  end

  def format( text )
    text.html_safe
  end

end
