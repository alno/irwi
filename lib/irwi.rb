module Irwi

  module Formatters; end
  module Comparators; end
  module Extensions; end
  module Paginators; end
  module Support; end

  def self.config
    require 'irwi/config'

    @@config ||= Irwi::Config.new
  end

end

require 'irwi/extensions/controllers'
require 'irwi/extensions/models'
require 'irwi/support/route_mapper' # Routes
require 'irwi/helpers'
