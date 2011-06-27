require "spec_helper"

describe Irwi::Comparators::DiffLcs do

  before(:each) do
    @c = Irwi::Comparators::DiffLcs.new
  end

  specify "should render change for replaced text" do
    @c.render_changes('AAA','BbB').should == '<span class="removed">AAA</span><span class="added">BbB</span>'
  end

  specify "should render no changes for same text" do
    @c.render_changes('vdsds','vdsds').should == 'vdsds'
  end

  specify "should render addition" do
    @c.render_changes('AAA','AABbA').should == 'AA<span class="added">Bb</span>A'
  end

  specify "should render deletion" do
    @c.render_changes('AdvsADA','AdDA').should == 'Ad<span class="removed">vsA</span>DA'
  end

  specify "should render changed with addition" do
    @c.render_changes('qwerty','qwasdfy').should == 'qw<span class="removed">ert</span><span class="added">asdf</span>y'
  end

  specify "should survive on nil in old" do
    @c.render_changes(nil,'AdDA').should == '<span class="added">AdDA</span>'
  end

  specify "should survive on nil in new" do
    @c.render_changes('AdDA',nil).should == '<span class="removed">AdDA</span>'
  end

  specify "should change \\n to <br />" do
    @c.render_changes("AdDA\nhhh",'').should == '<span class="removed">AdDA<br />hhh</span>'
  end

  specify "should change \\r\\n to <br />" do
    @c.render_changes("AdDA\r\nhhh",'').should == '<span class="removed">AdDA<br />hhh</span>'
  end

end
