module Irwi::Formatters

  # Available formatters in order of their priority
  PROVIDERS = %w(red_cloth red_carpet blue_cloth wiki_cloth simple_html)

  PROVIDERS.each do |fmt|
    autoload fmt.classify.to_sym, "irwi/formatters/#{fmt}"
  end

  def self.autodetect
    PROVIDERS.each do |f|
      begin
        return const_get(f.classify).new
      rescue LoadError
      end
    end
  end

end
