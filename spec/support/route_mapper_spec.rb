require "spec/spec_helper"
require 'action_controller'

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

  describe 'wiki routes' do
    before do
      @set = ActionController::Routing::RouteSet.new
      @mapper = ActionController::Routing::RouteSet::Mapper.new(@set)

      ActionController::Routing::RouteSet::Mapper.instance_eval do
        include Irwi::Support::RouteMapper
      end
      @mapper.wiki_root('/wiki')
    end

    def check_route path, params = {}
      @set.generate(params).should == path
      @set.recognize_path(path).should == params
    end

    it 'has a route of listing all the wikis' do
      check_route '/wiki/all', :controller => 'wiki_pages', :action => 'all', :root => '/wiki'
    end

    %w[compare new edit history].each do |act| 
      it "has a route for #{act} wiki" do
        check_route "/wiki/#{act}/wiki_path", :controller => 'wiki_pages', :action => act, :root => '/wiki', :path => ['wiki_path']
      end
    end

    # Unable to perform the recognize path test because of conditions. If you can , write it.
    %w[show update destroy].each do |act|
      it "has a route for #{act} wiki" do
        @set.generate({:controller => 'wiki_pages', :action => act, :root => '/wiki', :path => ['wiki_path']}).should == '/wiki/wiki_path'
      end
    end

    describe 'attachment routes' do
      it 'has a route for adding an attachment' do
        @set.generate({:controller => 'wiki_pages', :action => 'add_attachment', :root => '/wiki', :path => ['wiki_path']}).should == '/wiki/attach/wiki_path'
      end

      it 'has a route for deleting an attachment' do
        @set.generate({:controller => 'wiki_pages', :action => 'remove_attachment', :root => '/wiki', :attachment_id => 1}).should == '/wiki/attach/1'
      end
    end

  end
  
end
