require "spec_helper"

describe Irwi::Config do

  before(:each) do
    @o = Irwi::Config.new
  end

  specify "should save selected user_class_name" do
    @o.user_class_name = 'MyUserClass'
    @o.user_class_name.should == 'MyUserClass'
  end

  specify "should select 'User' as user_class_name by default" do
    @o.user_class_name.should == 'User'
  end

  specify "should save selected page_class_name" do
    @o.page_class_name = 'MyPageClass'
    @o.page_class_name.should == 'MyPageClass'
  end

  specify "should select 'WikiPage' as page_class_name by default" do
    @o.page_class_name.should == 'WikiPage'
  end

  specify "should save selected page_version_class_name" do
    @o.page_version_class_name = 'MyVersionClass'
    @o.page_version_class_name.should == 'MyVersionClass'
  end

  specify "should select 'WikiPageVersion' as page_version_class_name by default" do
    @o.page_version_class_name.should == 'WikiPageVersion'
  end

  specify "should save selected formatter" do
    @o.formatter = :my_formatter
    @o.formatter.should == :my_formatter
  end

  specify "should select RedCloth as formatter by default" do
    Irwi::Formatters::RedCloth.should_receive(:new).and_return(:red_cloth_formatter)

    @o.formatter.should == :red_cloth_formatter
  end

  specify "should save selected comparator" do
    @o.comparator = :my_formatter
    @o.comparator.should == :my_formatter
  end

  specify "should select DiffLcs as comparator by default" do
    Irwi::Comparators::DiffLcs.should_receive(:new).and_return(:diff_lcs_comparator)

    @o.comparator.should == :diff_lcs_comparator
  end

  specify "should contain 'all' action in system pages" do
    Irwi.config.system_pages['all'].should == 'all'
  end

  specify "should add action in system pages" do
    Irwi.config.system_pages['custom'].should be_nil
    Irwi.config.add_system_page :custom, '!custom_page'
    Irwi.config.system_pages['custom'].should == '!custom_page'
  end

end
