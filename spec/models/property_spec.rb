require 'spec_helper'

describe Property do
  describe "#full_street_address" do
    let(:property){ Property.new(address: "1600 Pennsylvania Ave", city: "Washington", state: "DC", zip: nil) }
    it "returns a complete address" do
      property.full_street_address.should == "1600 Pennsylvania Ave, Washington, DC "
    end
  end

  describe ".geocode_all", :vcr do
    before do
      Property.create(address: "1600 Pennsylvania Ave", city: "Washington", state: "DC")
    end
    it "geocodes all addresses" do
      Property.geocode_all
      Property.not_geocoded.count.should == 0
    end
  end

  describe ".current" do
    let(:date){ Date.new(2013, 01, 01) }
    let!(:current_property){ Property.create(address: "123", sale_date: date + 1.year ) }
    let!(:past_property){ Property.create(address: "321", sale_date: date - 1.year) }
    it "returns properties with a sale date after a given date" do
      Property.current(date).should include(current_property)
      Property.current(date).should_not include(past_property)
    end
  end
end
