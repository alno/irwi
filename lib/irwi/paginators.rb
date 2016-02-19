module Irwi::Paginators

  # Available formatters in order of their priority
  PROVIDERS = %w(will_paginate kaminari none)

  include Irwi::Support::Autodetector

end
