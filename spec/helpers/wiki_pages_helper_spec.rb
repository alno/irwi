require "spec_helper"

class PageAttachment < ActiveRecord::Base
end

describe Irwi::Helpers::WikiPagesHelper do
  it { is_expected.not_to be_nil }

  context "included in class" do
    subject do
      ActionView::Base.new.tap do |v|
        v.send :extend, ERB::Util
        v.send :extend, described_class
      end
    end

    it { is_expected.to respond_to(:wiki_page_form) }

    it { is_expected.to respond_to(:wiki_page_new_path) }
    it { is_expected.to respond_to(:wiki_page_edit_path) }
    it { is_expected.to respond_to(:wiki_page_history_path) }
    it { is_expected.to respond_to(:wiki_page_compare_path) }
    it { is_expected.to respond_to(:wiki_page_path) }

    specify "builds url_for params by wiki_page_new_path" do
      allow(subject).to receive(:params).and_return(path: 'newpath')
      expect(subject).to receive(:url_for).with(action: :new, path: 'newpath').and_return('newpath')

      expect(subject.wiki_page_new_path).to eq 'newpath'
    end

    specify "builds url_for params by wiki_page_new_path if path left blank" do
      allow(subject).to receive(:params).and_return(nil)
      expect(subject).to receive(:url_for).with(action: :new).and_return('blank_path')

      expect(subject.wiki_page_new_path).to eq('blank_path')
    end

    specify "builds url_for params by wiki_page_edit_path" do
      expect(subject).to receive(:url_for).with(action: :edit).and_return('epath')

      expect(subject.wiki_page_edit_path).to eq('epath')
    end

    specify "builds url_for params by wiki_page_edit_path with path" do
      expect(subject).to receive(:url_for).with(action: :edit, path: 'qwerty').and_return('epath')

      expect(subject.wiki_page_edit_path('qwerty')).to eq('epath')
    end

    specify "builds url_for params by wiki_page_history_path" do
      expect(subject).to receive(:url_for).with(action: :history).and_return('hpath')

      expect(subject.wiki_page_history_path).to eq('hpath')
    end

    specify "builds url_for params by wiki_page_compare_path" do
      expect(subject).to receive(:url_for).with(action: :compare).and_return('cpath')

      expect(subject.wiki_page_compare_path).to eq('cpath')
    end

    specify "builds url_for params by wiki_page_path" do
      expect(subject).to receive(:url_for).with(action: :show).and_return('spath')

      expect(subject.wiki_page_path).to eq('spath')
    end

    specify "builds url_for params by wiki_page_path with path" do
      expect(subject).to receive(:url_for).with(action: :show, path: '123').and_return('spath')

      expect(subject.wiki_page_path('123')).to eq('spath')
    end

    it { expect(subject).to respond_to(:wiki_content) }
    it { expect(subject).to respond_to(:wiki_diff) }
    it { expect(subject).to respond_to(:wiki_user) }

    it { expect(subject).to respond_to(:wiki_page_info) }
    it { expect(subject).to respond_to(:wiki_page_actions) }
    it { expect(subject).to respond_to(:wiki_page_history) }
    it { expect(subject).to respond_to(:wiki_page_style) }

    it { expect(subject).to respond_to(:wiki_link) }
    it { expect(subject).to respond_to(:wiki_linkify) }

    it { expect(subject).to respond_to(:wt) }

    specify "formats and sanitizes content with current formatter and #sanitize" do
      Irwi.config.formatter = double 'Formatter'
      expect(Irwi.config.formatter).to receive(:format).with('Page content').and_return('Formatted content')

      expect(subject).to receive(:auto_link).with('Formatted content').and_return('Formatted content with links')
      expect(subject).to receive(:sanitize).with('Formatted content with links').and_return('Formatted and sanitized content with links')

      expect(subject.wiki_content('Page content')).to eq('Formatted and sanitized content with links')
    end

    specify "renders wiki_page_info partial" do
      expect(subject).to receive(:template_dir).and_return('partial_dir')
      expect(subject).to receive(:render).with(partial: "partial_dir/wiki_page_info", locals: { page: 'MyPage' }).and_return('partial_body')

      expect(subject.wiki_page_info('MyPage')).to eq('partial_body')
    end

    specify "renders wiki_page_actions partial" do
      expect(subject).to receive(:template_dir).and_return('partial_dir')
      expect(subject).to receive(:render).with(partial: "partial_dir/wiki_page_actions", locals: { page: 'MyPage' }).and_return('partial_body')

      expect(subject.wiki_page_actions('MyPage')).to eq('partial_body')
    end

    specify "renders wiki_page_history partial" do
      expect(subject).to receive(:template_dir).and_return('partial_dir')
      expect(subject).to receive(:render).with(partial: "partial_dir/wiki_page_history", locals: { page: 'MyPage', versions: [1, 2], with_form: true }).and_return('partial_body')

      expect(subject.wiki_page_history('MyPage', [1, 2])).to eq('partial_body')
    end

    specify "renders wiki_page_history partial (with default versions)" do
      page = double 'MyPage'
      expect(page).to receive(:versions).and_return([1])

      expect(subject).to receive(:template_dir).and_return('partial_dir')
      expect(subject).to receive(:render).with(partial: "partial_dir/wiki_page_history", locals: { page: page, versions: [1], with_form: false }).and_return('partial_body')

      expect(subject.wiki_page_history(page)).to eq('partial_body')
    end

    specify "linkifies string" do
      expect(subject).to receive(:wiki_link).exactly(3).times.with('Some other page').and_return('url')

      expect(subject.wiki_linkify('[[Some other page]] - link')).to eq('<a href="url">Some other page</a> - link')
      expect(subject.wiki_linkify('[[Some other page|Go other page]] - link')).to eq('<a href="url">Go other page</a> - link')
      expect(subject.wiki_linkify('[[Some other page]]s are there')).to eq('<a href="url">Some other pages</a> are there')
    end

    specify "linkifies with anchors" do
      expect(subject).to receive(:wiki_link).once.with('Some other page').and_return('url')

      expect(subject.wiki_linkify('And [[Some other page#other|other page]]')).to eq('And <a href="url#other">other page</a>')
    end

    specify "generates link for non-existent page" do
      page_class = double "WikiPageClass"
      expect(page_class).to receive(:find_by_title).with('Page_title').and_return(nil)

      expect(Irwi.config).to receive(:page_class).and_return(page_class)

      expect(subject).to receive(:url_for).with(controller: 'wiki_pages', action: :show, path: 'Page_title').and_return('url')

      expect(subject.wiki_link('Page_title')).to eq('url')
    end

    specify "generates link for existent page" do
      page = double "WikiPage"
      expect(page).to receive(:path).and_return('page_path')

      page_class = double "WikiPageClass"
      expect(page_class).to receive(:find_by_title).with('Page title').and_return(page)

      expect(Irwi.config).to receive(:page_class).and_return(page_class)

      expect(subject).to receive(:url_for).with(controller: 'wiki_pages', action: :show, path: 'page_path').and_return('url')

      expect(subject.wiki_link('Page title')).to eq('url')
    end

    specify "not be vulnerable to XSS when showing a diff" do
      xss = '<script>alert("exploit")</script>'
      expect(subject.wiki_diff('foo bar', "foo #{xss} bar")).not_to include(xss)
    end

    it "renders wiki_page_form" do
      allow(subject).to receive(:url_for).and_return("some_url")
      allow(subject).to receive(:protect_against_forgery?).and_return(false)
      subject.instance_variable_set(:@page, double(id: 11, title: 'Some value'))

      code = subject.wiki_page_form do |f|
        f.text_field :title
      end

      expect(code).to include('<form')
    end

    it "renders wiki_page_attachments" do
      Irwi.config.page_attachment_class_name = 'PageAttachment'

      expect(subject).to receive(:template_dir).and_return('partial_dir')
      expect(subject).to receive(:render).with(partial: "partial_dir/wiki_page_attachments", locals: { page: 'MyPage' }).and_return('partial_body')

      expect(subject.wiki_page_attachments('MyPage')).to eq 'partial_body'
    end
  end
end
