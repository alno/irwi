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

  it { should_not be_nil }

  before :all do
    Irwi::config.page_attachment_class_name = nil

    @cls = Class.new AbstractPage do

      self.table_name  = 'pages'

      include Irwi::Extensions::Models::WikiPage

    end
  end

  context "class" do

    subject { @cls }

    it { should respond_to(:find) }
    it { should respond_to(:find_by_path_or_new) }

  end

  context "instance" do

    subject { @cls.new }

    it { should respond_to(:save) }
    it { should respond_to(:destroy) }

    it { should respond_to(:comment) }
    it { should respond_to(:previous_version_number) }

    it { should respond_to(:versions) }

    it { should_not respond_to(:attachments) }

  end

  context "with attachments" do

    before :all do
      Irwi::config.page_attachment_class_name = 'WikiPageAttachment'

      @cls = Class.new AbstractPage do

        self.table_name  = 'pages'

        include Irwi::Extensions::Models::WikiPage
      end
    end

    context "instance" do

      before :each do
        @obj = @cls.new
      end

      it { @obj.should respond_to(:attachments) }

    end

  end

end
