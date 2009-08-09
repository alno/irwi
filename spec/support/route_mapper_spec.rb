require "spec/spec_helper"

describe Riwiki::Support::RouteMapper do
  
  it { should_not be_nil }
  
  context "included in class" do
    
    before(:each) do
      @m = Object.new
      @m.send :extend, Riwiki::Support::RouteMapper
    end
    
    specify "should provide riwiki_root method" do 
      @m.should respond_to :riwiki_root 
    end
    
  end
  
end