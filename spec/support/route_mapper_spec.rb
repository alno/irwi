require "spec/spec_helper"

describe Irwi::Support::RouteMapper do
  
  it { should_not be_nil }
  
  context "included in class" do
    
    before(:each) do
      @m = Object.new
      @m.send :extend, Irwi::Support::RouteMapper
    end
    
    specify "should provide wiki_root method" do 
      @m.should respond_to(:wiki_root) 
    end
    
  end
  
end