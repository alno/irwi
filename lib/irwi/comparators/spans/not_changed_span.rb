class Irwi::Comparators::Spans::NotChangedSpan
    
  attr_accessor :value
   
  def initialize( v )
    @value = v
  end
    
  def to_s
    @value
  end
    
  def action
    '='
  end
    
  alias_method :old_value, :value
  alias_method :new_value, :value
    
end