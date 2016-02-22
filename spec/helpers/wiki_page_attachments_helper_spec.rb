require "spec_helper"

describe Irwi::Helpers::WikiPageAttachmentsHelper do
  it { is_expected.not_to be_nil }

  context "included in class" do
    subject { Object.new }

    before(:each) do
      Irwi.config.page_attachment_class_name = 'WikiPageAttachment'

      subject.send :extend, Irwi::Helpers::WikiPagesHelper
    end

    describe :wiki_show_attachment do
      before do
        class WikiPageAttachment; end
      end

      it 'replaces Attachment_1_thumb with its corresponding image tag' do
        paperclip_attachment = double('paperclip attachment')
        attachment = double(WikiPageAttachment, wiki_page_attachment: paperclip_attachment)

        expect(WikiPageAttachment).to receive(:find).with('1').and_return(attachment)
        expect(paperclip_attachment).to receive(:url).with(:thumb).and_return(:thumb_image)

        expect(subject).to receive(:image_tag).with(:thumb_image, class: 'wiki_page_attachment').and_return('thumb_image_markup')

        expect(subject.wiki_show_attachments('Foo Attachment_1_thumb Bar')).to eq 'Foo thumb_image_markup Bar'
      end

      it 'does not affect text without attachments' do
        expect(subject.wiki_show_attachments('Foo Bar')).to eq 'Foo Bar'
      end

      it 'ignores absent attachments' do
        expect(WikiPageAttachment).to receive(:find).with('10').and_raise(ActiveRecord::RecordNotFound)

        expect(subject.wiki_show_attachments('Foo Attachment_10_thumb Bar')).to eq 'Foo  Bar'
      end
    end
  end
end
