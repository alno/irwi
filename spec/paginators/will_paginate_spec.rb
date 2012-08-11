require "spec_helper"

describe Irwi::Paginators::WillPaginate do

  let(:p) { Irwi::Paginators::WillPaginate.new }

  specify "should paginate collection" do
    coll = mock "Collection"
    coll.should_receive(:paginate).with( :page => 15 ).and_return("paginated_collection")

    p.paginate( coll, :page => 15 ).should == "paginated_collection"
  end

  specify "should render paginated collection" do
    block = lambda { 11 }
    coll = []
    view = mock "View"
    view.should_receive(:paginated_section).with( coll, &block ).and_return("result")

    p.paginated_section( view, coll, &block ).should == "result"
  end

end
