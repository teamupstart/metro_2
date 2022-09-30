require "spec_helper"

describe Metro2::Records::BaseSegment do
  before do
    @j2_segment = Metro2::Records::J2Segment.new
    @j2_segment.surname = business_name
    @j2_segment.social_security_number = "333224444"
    @j2_segment.date_of_birth = Date.new(1987, 4, 19)
    @j2_segment.ecoa_code = "W"
    @j2_segment.country_code = 'US'
    @j2_segment.address_1 = '742 Evergreen Terrace'
    @j2_segment.city = 'Springfield'
    @j2_segment.state = 'IL'
    @j2_segment.postal_code = '54321'
  end

  context "#to_metro2" do
    let(:expected) do
      [
        "J2",
        " ",
        business_name.to_s.ljust(25, ' '),
        " " * 20,
        " " * 20,
        " ",
        "333224444",
        "04191987",
        "0" * 10,
        "W",
        " " * 2,
        "US",
        "742 Evergreen Terrace".ljust(32, ' '),
        " " * 32,
        "Springfield".ljust(20, ' '),
        "IL",
        "54321".ljust(9, ' '),
        " ",
        " ",
        " " * 2
      ]
    end

    context "with valid attributes set" do
      let(:business_name) { "Business Name" }

      it "should create output string that matches expected" do
        j2_segment_str = @j2_segment.to_metro2
        expect(j2_segment_str).to eql(expected.join)
        expect(j2_segment_str.size).to eql(Metro2::Records::J2Segment::LENGTH)
      end
    end
  end
end