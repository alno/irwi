class Riwiki::Options
  
  def user_class_name
    @user_class ||= select_user_class_name
  end
  
  def user_class_name=(uc)
    @user_class = uc.to_s
  end
  
  def formatter
    @formatter ||= select_formatter
  end
  
  def formatter=(fmt)
    @formatter = fmt
  end
  
  private
  
  def select_user_class_name
    'User'
  end

  def select_formatter
    Riwiki::Formatters::RedCloth.new
  end
  
end