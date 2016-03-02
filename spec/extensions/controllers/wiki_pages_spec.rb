require "spec_helper"

require "action_controller"

describe Irwi::Extensions::Controllers::WikiPages do
  class WikiPage; end
  class WikiPagesController < ActionController::Base
    include Irwi::Extensions::Controllers::WikiPages

    private

    def current_user
      'Some user'
    end
  end

  it { is_expected.not_to be_nil }

  let(:cls) { WikiPagesController }

  context "class" do
    subject { cls }

    it { is_expected.to respond_to(:set_page_class) }
    it { is_expected.to respond_to(:page_class) }

    specify "should have WikiPage as default page_class" do
      expect(subject.page_class).to eq(WikiPage)
    end
  end

  context "instance" do
    subject { cls.new }

    specify "should have WikiPage as default page_class" do
      expect(subject.send(:page_class)).to be WikiPage
    end

    it { is_expected.to respond_to(:show) }
    it { is_expected.to respond_to(:new) }
    it { is_expected.to respond_to(:edit) }
    it { is_expected.to respond_to(:update) }
    it { is_expected.to respond_to(:history) }
    it { is_expected.to respond_to(:compare) }
    it { is_expected.to respond_to(:destroy) }

    specify "should correctly handle current_user" do
      subject.send(:setup_current_user)
      expect(subject.send(:current_user)).to eq 'Some user'
      expect(subject.instance_variable_get(:@current_user)).to eq 'Some user'
    end
  end
end
