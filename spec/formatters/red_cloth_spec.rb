require "spec_helper"

describe Irwi::Formatters::RedCloth do
  specify "should proces bold text" do
    expect(subject.format('*Place* ff')).to eq('<p><strong>Place</strong> ff</p>')
  end

  specify "should proces italic text" do
    expect(subject.format('_Mom_ ff')).to eq('<p><em>Mom</em> ff</p>')
  end
end
