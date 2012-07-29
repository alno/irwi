require 'active_support/dependencies'
require 'rails_autolink' if defined?(Rails)

module Irwi

  module Formatters
    autoload :BlueCloth, 'irwi/formatters/blue_cloth'
    autoload :RedCloth, 'irwi/formatters/red_cloth'
    autoload :SimpleHtml, 'irwi/formatters/simple_html'
    autoload :WikiCloth, 'irwi/formatters/wiki_cloth'
  end

  module Comparators
    autoload :DiffLcs, 'irwi/comparators/diff_lcs'
    autoload :Base, 'irwi/comparators/base'
    module Spans
      autoload :ChangedSpan, 'irwi/comparators/spans/changed_span'
      autoload :NotChangedSpan, 'irwi/comparators/spans/not_changed_span'
    end
  end

  module Extensions; end

  module Paginators
    autoload :None, 'irwi/paginators/none'
    autoload :WillPaginate, 'irwi/paginators/will_paginate'
  end

  module Support
    autoload :TemplateFinder, 'irwi/support/template_finder'
  end

  def self.config
    require 'irwi/config'

    @@config ||= Irwi::Config.new
  end

end

require 'irwi/extensions/controllers'
require 'irwi/extensions/models'
require 'irwi/support/route_mapper' # Routes
require 'irwi/helpers'

ActionController::Base.append_view_path File.expand_path('../../app/views', __FILE__) # Append default views
