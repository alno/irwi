class Irwi::Comparators::Spans::ChangedSpan

  attr_accessor :action, :old_value, :new_value

  def initialize( act, ov, nv )
    @action = act
    @old_value = ov
    @new_value = nv
  end

  def to_s
    s = ''
    s << "<span class=\"removed\">#{@old_value}</span>" if @old_value
    s << "<span class=\"added\">#{@new_value}</span>" if @new_value
    s
  end

end
