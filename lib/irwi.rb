module Irwi
  
  module Formatters; end
  module Comparators; end
  module Extensions; end
  module Helpers; end
  module Paginators; end
  module Support; end
  
  def self.config
    @@config ||= Irwi::Config.new
  end
  
end
