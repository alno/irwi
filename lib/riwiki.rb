module Riwiki
  
  def self.config
    @@config ||= Riwiki::Config.new
  end
  
end
