require "spec_helper"

describe Irwi::Formatters::RedCloth do

  let(:f) { Irwi::Formatters::RedCloth.new }

  specify "should proces bold text" do
    f.format('*Place* ff').should == '<p><strong>Place</strong> ff</p>'
  end

  specify "should proces italic text" do
    f.format('_Mom_ ff').should == '<p><em>Mom</em> ff</p>'
  end

end
