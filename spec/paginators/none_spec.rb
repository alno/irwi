require "spec_helper"

describe Irwi::Paginators::None do
  specify "should paginate collection - call find" do
    coll = double "Collection"
    expect(coll).to receive(:all).and_return("full collection")

    expect(subject.paginate(coll, page: 10)).to eq("full collection")
  end

  specify "should render paginated section" do
    a = nil
    subject.paginated_section "view", "collection" do
      a = true
    end
    expect(a).to be true
  end
end
