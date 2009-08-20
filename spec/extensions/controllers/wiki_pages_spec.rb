require "spec/spec_helper"

require "action_controller"

class WikiPage; end

describe Riwiki::Extensions::Controllers::WikiPages do
  
  it { should_not be_nil }
    
  before(:all) do
    @cls = Class.new ActionController::Base do
      include Riwiki::Extensions::Controllers::WikiPages
    end
  end
  
  context "class" do    
    
    it { @cls.should respond_to :set_page_class }
    it { @cls.should respond_to :page_class }
    
    specify "should have WikiPage as default page_class" do
      @cls.page_class.should == WikiPage
    end
    
  end
  
  context "instance" do
    
    before(:each) do      
      @obj = @cls.new
    end
    
    it { @obj.should respond_to :page_class }
    
    specify "should have WikiPage as default page_class" do
      @obj.send(:page_class).should == WikiPage
    end

    it { @obj.should respond_to :render_template }
    it { @obj.should respond_to :setup_current_user }
    it { @obj.should respond_to :setup_page }

    it { @obj.should respond_to :show }
    it { @obj.should respond_to :edit }
    it { @obj.should respond_to :update }
                
  end
  
end