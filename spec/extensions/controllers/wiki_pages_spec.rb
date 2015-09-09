require "spec_helper"

require "action_controller"

describe Irwi::Extensions::Controllers::WikiPages do

  class WikiPage; end
  class WikiPagesController < ActionController::Base
    include Irwi::Extensions::Controllers::WikiPages

    private

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = 'Some user'
    end

  end

  it { should_not be_nil }

  before(:all) do
    @cls = WikiPagesController
  end

  context "class" do

    it { @cls.should respond_to(:set_page_class) }
    it { @cls.should respond_to(:page_class) }

    specify "should have WikiPage as default page_class" do
      @cls.page_class.should == WikiPage
    end

  end

  context "instance" do

    subject { @cls.new }

    specify "should have WikiPage as default page_class" do
      subject.send(:page_class).should be WikiPage
    end

    it { should respond_to(:show) }
    it { should respond_to(:new) }
    it { should respond_to(:edit) }
    it { should respond_to(:update) }
    it { should respond_to(:history) }
    it { should respond_to(:compare) }
    it { should respond_to(:destroy) }

    specify "should correctly handle current_user" do
      subject.send(:setup_current_user)
      subject.send(:current_user).should eq 'Some user'
      subject.instance_variable_get(:@current_user).should eq 'Some user'
    end

  end

end
