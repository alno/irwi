require "spec_helper"

describe Irwi::Helpers::WikiPageAttachmentsHelper do

  it { should_not be_nil }

  context "included in class" do

    before(:each) do
      Irwi.config.page_attachment_class_name = 'WikiPageAttachment'
      @m = Object.new
      @m.send :extend, Irwi::Helpers::WikiPagesHelper
    end

    describe :wiki_show_attachment do
      before do
        class WikiPageAttachment; end
      end

      it 'replaces Attachment_1_thumb with its corresponding image tag' do
        paperclip_attachment = mock('paperclip attachment')
        attachment = mock(WikiPageAttachment, :wiki_page_attachment => paperclip_attachment)

        WikiPageAttachment.should_receive(:find).with('1').and_return(attachment)
        paperclip_attachment.should_receive(:url).with(:thumb).and_return(:thumb_image)
        @m.should_receive(:image_tag).with(:thumb_image, :class => 'wiki_page_attachment').and_return('thumb_image_markup')

        @m.wiki_show_attachments('Foo Attachment_1_thumb Bar').should == 'Foo thumb_image_markup Bar'
      end

      it 'does not affect text without attachments' do
        @m.wiki_show_attachments('Foo Bar').should == 'Foo Bar'
      end

      it 'ignores absent attachments' do
        paperclip_attachment = mock('paperclip attachment')
        attachment = mock(WikiPageAttachment, :wiki_page_attachment => paperclip_attachment)
        WikiPageAttachment.should_receive(:find).with('10').and_raise(ActiveRecord::RecordNotFound)

        @m.wiki_show_attachments('Foo Attachment_10_thumb Bar').should == 'Foo  Bar'
      end
    end

  end
end
