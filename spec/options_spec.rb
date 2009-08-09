require "spec/spec_helper"

describe Riwiki::Options do
      
  before(:each) do
    @o = Riwiki::Options.new
  end
    
  specify "should save selected user_class_name" do 
    @o.user_class_name = 'MyUserClass'
    @o.user_class_name.should == 'MyUserClass'
  end
  
  specify "should select 'User' as user_class_name by default" do
    @o.user_class_name.should == 'User'
  end
  
  specify "should save selected formatter" do 
    @o.formatter = :my_formatter
    @o.formatter.should == :my_formatter
  end
  
  specify "should select RedCloth as formatter by default" do
    Riwiki::Formatters::RedCloth.should_receive(:new).and_return(:red_cloth_formatter)
    
    @o.formatter.should == :red_cloth_formatter
  end
  
end