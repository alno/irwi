require 'rubygems'

require 'active_support/test_case'
require 'active_record'
require 'irwi'
require 'irwi/config'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

begin
  ActiveRecord::Schema.drop_table('pages')
rescue
  nil
end

ActiveRecord::Schema.define do
  create_table "pages", :force => true do |t|
    t.column "title", :string, :limit => 255, :null => false
    t.column "path", :string, :limit => 255, :null => false
    t.column "content", :text , :null => false
  end

  create_table "page_attachments", :force => true do |t|
    t.column "page_id", :integer, :null => false
    t.column "wiki_page_attachment", :string, :limit => 255, :null => false
  end
end

RSpec.configure do |config|
end

module Irwi::Helpers::WikiPagesHelper
  attr_accessor :params
end
