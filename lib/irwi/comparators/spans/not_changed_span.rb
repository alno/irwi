class Irwi::Comparators::Spans::NotChangedSpan
  attr_accessor :value

  def initialize(v)
    @value = v
  end

  def to_s
    @value.to_s
  end

  def action
    '='
  end

  alias old_value value
  alias new_value value
end
