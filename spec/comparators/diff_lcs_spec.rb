require "spec_helper"

describe Irwi::Comparators::DiffLcs do
  specify "should render change for replaced text" do
    expect(subject.render_changes('AAA', 'BbB')).to eq('<span class="removed">AAA</span><span class="added">BbB</span>')
  end

  specify "should render no changes for same text" do
    expect(subject.render_changes('vdsds', 'vdsds')).to eq('vdsds')
  end

  specify "should render addition" do
    expect(subject.render_changes('AAA', 'AABbA')).to eq('AA<span class="added">Bb</span>A')
  end

  specify "should render deletion" do
    expect(subject.render_changes('AdvsADA', 'AdDA')).to eq('Ad<span class="removed">vsA</span>DA')
  end

  specify "should render changed with addition" do
    expect(subject.render_changes('qwerty', 'qwasdfy')).to eq('qw<span class="removed">ert</span><span class="added">asdf</span>y')
  end

  specify "should survive on nil in old" do
    expect(subject.render_changes(nil, 'AdDA')).to eq('<span class="added">AdDA</span>')
  end

  specify "should survive on nil in new" do
    expect(subject.render_changes('AdDA', nil)).to eq('<span class="removed">AdDA</span>')
  end

  specify "should change \\n to <br />" do
    expect(subject.render_changes("AdDA\nhhh", '')).to eq('<span class="removed">AdDA<br />hhh</span>')
  end

  specify "should change \\r\\n to <br />" do
    expect(subject.render_changes("AdDA\r\nhhh", '')).to eq('<span class="removed">AdDA<br />hhh</span>')
  end
end
