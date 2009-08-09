require "spec/spec_helper"

describe Riwiki::Helpers::WikiPagesHelper do
  
  it { should_not be_nil }
  
  context "included in class" do
    
    before(:each) do
      @m = Object.new
      @m.send :extend, Riwiki::Helpers::WikiPagesHelper
    end
    
    it { @m.should respond_to :wiki_page_form }
    
    it { @m.should respond_to :wiki_page_edit_path }
    it { @m.should respond_to :wiki_page_history_path }
    it { @m.should respond_to :wiki_page_path }
    
    it { @m.should respond_to :wiki_content }
    it { @m.should respond_to :wiki_user }
    
    it { @m.should respond_to :wiki_page_info }
    it { @m.should respond_to :wiki_page_actions }
    
    specify "should format and sanitize content with current formatter and #sanitize" do      
      Riwiki.options.formatter = mock 'Formatter'
      Riwiki.options.formatter.should_receive(:format).with('Page content').and_return('Formatted content')
      
      @m.should_receive(:sanitize).with('Formatted content').and_return('Formatted and sanitized content')
      
      @m.wiki_content( 'Page content' ).should == 'Formatted and sanitized content'
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
    
  end
  
end