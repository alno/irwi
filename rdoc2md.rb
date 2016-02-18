require 'rdoc'
converter = RDoc::Markup::ToMarkdown.new
rdoc = File.read(ARGV[0] || 'README.rdoc')
puts converter.convert(rdoc)
