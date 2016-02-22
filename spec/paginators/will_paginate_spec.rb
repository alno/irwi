require "spec_helper"

describe Irwi::Paginators::WillPaginate do
  specify "should paginate collection" do
    coll = double "Collection"
    expect(coll).to receive(:paginate).with(page: 15).and_return("paginated_collection")

    expect(subject.paginate(coll, page: 15)).to eq("paginated_collection")
  end

  specify "should render paginated collection" do
    block = ->(_x) { 11 }
    coll = []
    view = double "View"
    expect(view).to receive(:paginated_section).with(coll, &block).and_return("result")

    expect(subject.paginated_section(view, coll, &block)).to eq("result")
  end
end
