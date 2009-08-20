require "spec/spec_helper"

require "action_controller"

describe Riwiki::Extensions::Controllers::WikiPages do
  
  it { should_not be_nil }
  
  context "included in class" do
    
    before(:each) do
      @cls = Class.new ActionController::Base do
        include Riwiki::Extensions::Controllers::WikiPages
      end
      @obj = @cls.new
    end
    
    
    it { @cls.should respond_to :set_page_class }
    it { @cls.should respond_to :page_class }    
    it { @obj.should respond_to :page_class }

    it { @obj.should respond_to :render_template }
    it { @obj.should respond_to :setup_current_user }
    it { @obj.should respond_to :setup_page }

    it { @obj.should respond_to :show }
    it { @obj.should respond_to :edit }
    it { @obj.should respond_to :update }
                
  end
  
end