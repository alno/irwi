require "spec/spec_helper"

require "action_controller"

describe Irwi::Extensions::Controllers::WikiPages do  
  
  class WikiPage; end
  class WikiPagesController < ActionController::Base
    include Irwi::Extensions::Controllers::WikiPages
  end
  
  it { should_not be_nil }
    
  before(:all) do
    @cls = WikiPagesController
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
    it { @obj.should respond_to :history }
    it { @obj.should respond_to :compare }
    it { @obj.should respond_to :destroy }
                
  end
  
end