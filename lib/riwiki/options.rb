class Riwiki::Options
  
  def user_class
    @user_class ||= select_user_class
  end
  
  def user_class=(uc)
    @user_class = uc.is_a? Class ? uc : uc.constantize
  end
  
  def formatter
    @formatter ||= select_formatter
  end
  
  def formatter=(fmt)
    @formatter = fmt
  end
  
  private
  
  def select_user_class
    'User'.constantize
  end

  def select_formatter
    Riwiki::Formatters::RedCloth.new
  end
  
end