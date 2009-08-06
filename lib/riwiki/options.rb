class Riwiki::Options
  
  def self.user_class
    @@user_class ||= 'User'.constantize
  end
  
  def self.user_class=(uc)
    @@user_class = uc.is_a? Class ? uc : uc.constantize
  end
  
end