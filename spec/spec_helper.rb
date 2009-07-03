require 'rubygems'
require 'active_support'
require 'active_support/test_case'

ActiveSupport::Dependencies.load_paths << "#{File.dirname(__FILE__)}/../lib"
ActiveSupport::Dependencies.load_paths << "#{File.dirname(__FILE__)}/../app/models"
ActiveSupport::Dependencies.load_paths << "#{File.dirname(__FILE__)}/../app/controllers"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
end
