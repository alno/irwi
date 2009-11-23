module Irwi
  
  def self.config
    require 'irwi/config'

    @@config ||= Irwi::Config.new
  end
  
end
