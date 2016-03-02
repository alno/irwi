require "spec_helper"

require "active_record"

describe Irwi::Extensions::Models::WikiPage do
  class AbstractPage < ActiveRecord::Base
    def self.columns
      c = ActiveRecord::ConnectionAdapters::Column

      [
        c.new("title", nil, "string", false),
        c.new("path", nil, "string", false),
        c.new("content", nil, "text", false)
      ]
    end
  end

  it { is_expected.not_to be_nil }

  before :all do
    Irwi.config.page_attachment_class_name = nil
  end

  let :cls do
    Class.new AbstractPage do
      self.table_name = 'pages'

      acts_as_wiki_page
    end
  end

  context "class" do
    subject { cls }

    it { is_expected.to respond_to(:find) }
    it { is_expected.to respond_to(:find_by_path_or_new) }
  end

  context "instance" do
    subject { cls.new }

    it { is_expected.to respond_to(:save) }
    it { is_expected.to respond_to(:destroy) }

    it { is_expected.to respond_to(:comment) }
    it { is_expected.to respond_to(:previous_version_number) }

    it { is_expected.to respond_to(:versions) }

    it { is_expected.not_to respond_to(:attachments) }
  end

  context "with attachments" do
    before :all do
      Irwi.config.page_attachment_class_name = 'WikiPageAttachment'
    end

    let :cls do
      Class.new AbstractPage do
        self.table_name = 'pages'

        acts_as_wiki_page
      end
    end

    context "instance" do
      subject { cls.new }

      it { is_expected.to respond_to(:attachments) }
    end
  end
end
