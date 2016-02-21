module Irwi::Formatters
  # Available formatters in order of their priority
  PROVIDERS = %w(red_cloth red_carpet blue_cloth wiki_cloth simple_html).freeze

  include Irwi::Support::Autodetector
end
