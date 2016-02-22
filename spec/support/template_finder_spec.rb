require "spec_helper"

describe Irwi::Support::TemplateFinder do
  it { is_expected.not_to be_nil }

  context "included in class" do
    subject { Object.new }

    before(:each) do
      subject.send :extend, described_class

      allow(subject).to receive(:controller_path).and_return('my_controller')
    end

    specify "should provide template_dir method" do
      expect(subject).to respond_to(:template_dir)
    end

    specify "should select template at controller_path when exists" do
      expect(Dir).to receive(:glob).with("app/views/my_controller/my_template.html.*").and_return(['some_template'])

      expect(subject.send(:template_dir, 'my_template')).to eq 'my_controller'
    end

    specify "should select template in base dir when it doesn't exists at controller_path" do
      expect(Dir).to receive(:glob).with("app/views/my_controller/my_template.html.*").and_return([])

      expect(subject.send(:template_dir, 'my_template')).to eq 'base_wiki_pages'
    end
  end
end
