require 'active_support/concern'

module Irwi::Support::Autodetector
  extend ActiveSupport::Concern

  included do
    const_get(:PROVIDERS).each do |fmt|
      autoload fmt.classify.to_sym, "#{name.underscore}/#{fmt}"
    end
  end

  module ClassMethods
    def autodetect
      const_get(:PROVIDERS).each do |f|
        begin
          return const_get(f.classify).new
        rescue LoadError
        end
      end
    end
  end
end
