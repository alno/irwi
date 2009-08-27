class Irwi::Comparators::Base
    
  def render_changes( old_text, new_text )
    build_changes( old_text, new_text ).join('')
  end
  
  protected
  
  def new_not_changed( value )
    Irwi::Comparators::Spans::NotChangedSpan.new( value )
  end
  
  def new_changed( action, old_value, new_value )
    Irwi::Comparators::Spans::ChangedSpan.new( action, old_value, new_value )
  end
    
end