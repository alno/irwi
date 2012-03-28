require "spec_helper"

class PageAttachment < ActiveRecord::Base
end

describe Irwi::Helpers::WikiPagesHelper do

  it { should_not be_nil }

  context "included in class" do

    before(:each) do
      @m = ActionView::Base.new
      @m.send :extend, ERB::Util
      @m.send :extend, Irwi::Helpers::WikiPagesHelper
    end

    it { @m.should respond_to(:wiki_page_form) }

    it { @m.should respond_to(:wiki_page_new_path) }
    it { @m.should respond_to(:wiki_page_edit_path) }
    it { @m.should respond_to(:wiki_page_history_path) }
    it { @m.should respond_to(:wiki_page_compare_path) }
    it { @m.should respond_to(:wiki_page_path) }

    specify "should form url_for by wiki_page_new_path" do
      @m.stub(:params).and_return({:path => 'newpath'})
      @m.should_receive(:url_for).with(:action => :new, :path => 'newpath').and_return('newpath')

      @m.wiki_page_new_path.should == 'newpath'
    end

    specify "should form url_for by wiki_page_new_path if path left blank" do
      @m.stub(:params).and_return(nil)
      @m.should_receive(:url_for).with(:action => :new).and_return('blank_path')

      @m.wiki_page_new_path.should == 'blank_path'
    end

    specify "should form url_for by wiki_page_edit_path" do
      @m.should_receive(:url_for).with(:action => :edit).and_return('epath')

      @m.wiki_page_edit_path.should == 'epath'
    end

    specify "should form url_for by wiki_page_edit_path with path" do
      @m.should_receive(:url_for).with(:action => :edit, :path => 'qwerty').and_return('epath')

      @m.wiki_page_edit_path('qwerty').should == 'epath'
    end

    specify "should form url_for by wiki_page_history_path" do
      @m.should_receive(:url_for).with(:action => :history).and_return('hpath')

      @m.wiki_page_history_path.should == 'hpath'
    end

    specify "should form url_for by wiki_page_compare_path" do
      @m.should_receive(:url_for).with(:action => :compare).and_return('cpath')

      @m.wiki_page_compare_path.should == 'cpath'
    end

    specify "should form url_for by wiki_page_path" do
      @m.should_receive(:url_for).with(:action => :show).and_return('spath')

      @m.wiki_page_path.should == 'spath'
    end

    specify "should form url_for by wiki_page_path with path" do
      @m.should_receive(:url_for).with(:action => :show, :path => '123').and_return('spath')

      @m.wiki_page_path('123').should == 'spath'
    end

    it { @m.should respond_to(:wiki_content) }
    it { @m.should respond_to(:wiki_diff) }
    it { @m.should respond_to(:wiki_user) }

    it { @m.should respond_to(:wiki_page_info) }
    it { @m.should respond_to(:wiki_page_actions) }
    it { @m.should respond_to(:wiki_page_history) }
    it { @m.should respond_to(:wiki_page_style) }

    it { @m.should respond_to(:wiki_link) }
    it { @m.should respond_to(:wiki_linkify) }

    it { @m.should respond_to(:wt) }

    specify "should format and sanitize content with current formatter and #sanitize" do
      Irwi.config.formatter = mock 'Formatter'
      Irwi.config.formatter.should_receive(:format).with('Page content').and_return('Formatted content')

      @m.should_receive(:auto_link).with('Formatted content').and_return('Formatted content with links')
      @m.should_receive(:sanitize).with('Formatted content with links').and_return('Formatted and sanitized content with links')

      @m.wiki_content( 'Page content' ).should == 'Formatted and sanitized content with links'
    end

    specify "should render wiki_page_info partial" do
      @m.should_receive(:template_dir).and_return('partial_dir')
      @m.should_receive(:render).with(:partial => "partial_dir/wiki_page_info", :locals => { :page => 'MyPage' }).and_return('partial_body')

      @m.wiki_page_info( 'MyPage' ).should == 'partial_body'
    end

    specify "should render wiki_page_actions partial" do
      @m.should_receive(:template_dir).and_return('partial_dir')
      @m.should_receive(:render).with(:partial => "partial_dir/wiki_page_actions", :locals => { :page => 'MyPage' }).and_return('partial_body')

      @m.wiki_page_actions( 'MyPage' ).should == 'partial_body'
    end

    specify "should render wiki_page_history partial" do
      @m.should_receive(:template_dir).and_return('partial_dir')
      @m.should_receive(:render).with(:partial => "partial_dir/wiki_page_history", :locals => { :page => 'MyPage', :versions => [1,2], :with_form => true }).and_return('partial_body')

      @m.wiki_page_history( 'MyPage', [1,2] ).should == 'partial_body'
    end

    specify "should render wiki_page_history partial (with default versions)" do
      page = mock 'MyPage'
      page.should_receive(:versions).and_return([1])

      @m.should_receive(:template_dir).and_return('partial_dir')
      @m.should_receive(:render).with(:partial => "partial_dir/wiki_page_history", :locals => { :page => page, :versions => [1], :with_form => false }).and_return('partial_body')

      @m.wiki_page_history( page ).should == 'partial_body'
    end

    specify "should linkify string" do
      @m.should_receive(:wiki_link).exactly(3).times.with('Some other page').and_return('url')

      @m.wiki_linkify( '[[Some other page]] - link' ).should == '<a href="url">Some other page</a> - link'
      @m.wiki_linkify( '[[Some other page|Go other page]] - link' ).should == '<a href="url">Go other page</a> - link'
      @m.wiki_linkify( '[[Some other page]]s are there' ).should == '<a href="url">Some other pages</a> are there'
    end

    specify "should linkify with anchors" do
      @m.should_receive(:wiki_link).once.with('Some other page').and_return('url')

      @m.wiki_linkify( 'And [[Some other page#other|other page]]' ).should == 'And <a href="url#other">other page</a>'
    end

    specify "should generate link for non-existent page" do
      page_class = mock "WikiPageClass"
      page_class.should_receive(:find_by_title).with('Page_title').and_return(nil)

      Irwi.config.should_receive(:page_class).and_return(page_class)

      @m.should_receive(:url_for).with( :controller => 'wiki_pages', :action => :show, :path => 'Page_title' ).and_return('url')

      @m.wiki_link( 'Page_title' ).should == 'url'
    end

    specify "should generate link for existent page" do
      page = mock "WikiPage"
      page.should_receive(:path).and_return('page_path')

      page_class = mock "WikiPageClass"
      page_class.should_receive(:find_by_title).with('Page title').and_return(page)

      Irwi.config.should_receive(:page_class).and_return(page_class)

      @m.should_receive(:url_for).with( :controller => 'wiki_pages', :action => :show, :path => 'page_path' ).and_return('url')

      @m.wiki_link( 'Page title' ).should == 'url'
    end

    specify "not be vulnerable to XSS when showing a diff" do
      xss = '<script>alert("exploit")</script>'
      @m.wiki_diff('foo bar', "foo #{xss} bar").should_not include(xss)
    end

    it "should render wiki_page_form" do
      @m.stub(:url_for).and_return("some_url")
      @m.stub(:protect_against_forgery?).and_return(false)

      code = @m.wiki_page_form do |f|
        f.text_field :title
      end

      code.should include('<form')
    end

    it "should render wiki_page_attachments" do
      Irwi::config.page_attachment_class_name = 'PageAttachment'

      @m.stub(:url_for).and_return("some_url")
      @m.stub(:protect_against_forgery?).and_return(false)

      code = @m.wiki_page_attachments(stub(:id => 11, :attachments => []))
      code.should include('<form')
    end

  end

end
