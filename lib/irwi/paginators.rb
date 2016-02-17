module Irwi::Paginators

  # Available formatters in order of their priority
  PROVIDERS = %w(will_paginate none)

  include Irwi::Support::Autodetector

end
