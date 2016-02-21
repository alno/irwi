require "spec_helper"

describe Irwi::Config do
  specify "should save selected user_class_name" do
    subject.user_class_name = 'MyUserClass'
    expect(subject.user_class_name).to eq 'MyUserClass'
  end

  specify "should select 'User' as user_class_name by default" do
    expect(subject.user_class_name).to eq 'User'
  end

  specify "should save selected page_class_name" do
    subject.page_class_name = 'MyPageClass'
    expect(subject.page_class_name).to eq 'MyPageClass'
  end

  specify "should select 'WikiPage' as page_class_name by default" do
    expect(subject.page_class_name).to eq 'WikiPage'
  end

  specify "should save selected page_version_class_name" do
    subject.page_version_class_name = 'MyVersionClass'
    expect(subject.page_version_class_name).to eq 'MyVersionClass'
  end

  specify "should select 'WikiPageVersion' as page_version_class_name by default" do
    expect(subject.page_version_class_name).to eq 'WikiPageVersion'
  end

  specify "should save selected formatter" do
    subject.formatter = :my_formatter
    expect(subject.formatter).to eq :my_formatter
  end

  specify "should select RedCloth as formatter by default" do
    expect(Irwi::Formatters::RedCloth).to receive(:new).and_return(:red_cloth_formatter)

    expect(subject.formatter).to eq :red_cloth_formatter
  end

  specify "should save selected comparator" do
    subject.comparator = :my_formatter
    expect(subject.comparator).to eq :my_formatter
  end

  specify "should select DiffLcs as comparator by default" do
    expect(Irwi::Comparators::DiffLcs).to receive(:new).and_return(:diff_lcs_comparator)

    expect(subject.comparator).to eq :diff_lcs_comparator
  end

  specify "should contain 'all' action in system pages" do
    expect(Irwi.config.system_pages['all']).to eq 'all'
  end

  specify "should add action in system pages" do
    expect(Irwi.config.system_pages['custom']).to be_nil

    Irwi.config.add_system_page :custom, '!custom_page'

    expect(Irwi.config.system_pages['custom']).to eq '!custom_page'
  end
end
