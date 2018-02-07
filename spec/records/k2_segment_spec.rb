require "spec_helper"

describe Metro2::Records::BaseSegment do
  before do
    @k2_segment = Metro2::Records::K2Segment.new
    @k2_segment.purchased_from_sold_to_indicator = indicator
    @k2_segment.purchased_from_sold_to_name = company_name
  end

  context "#to_metro2" do
    let(:expected) { ["K2", indicator.to_s, company_name.to_s.ljust(30, " "), " "] }

    context "with valid attributes set" do
      let(:indicator) { 1 }
      let(:company_name) { "Loan Buying Company" }

      it "should create output string that matches expected" do
        k2_segment_str = @k2_segment.to_metro2
        expect(k2_segment_str).to eql(expected.join)
        expect(k2_segment_str.size).to eql(Metro2::Records::K2Segment::LENGTH)
      end
    end

    context "with a 9 indicator" do
      let(:indicator) { 9 }

      context "with a blank purchased_from_sold_to_name" do
        let(:company_name) { nil }

        it "should create output string that matches expected" do
          k2_segment_str = @k2_segment.to_metro2
          expect(k2_segment_str).to eql(expected.join)
          expect(k2_segment_str.size).to eql(Metro2::Records::K2Segment::LENGTH)
        end
      end

      context "with purchased_from_sold_to_name that is not blank" do
        let(:company_name) { "Loan Buying Company" }

        it "should raise an error that the field should be blank" do
          expect { @k2_segment.to_metro2 }.
              to raise_error(/purchased_from_sold_to_name must be blank/)
        end
      end
    end

    context "with a non-supported indicator" do
      let(:indicator) { 7 }
      let(:company_name) { "Loan Buying Company" }

      it "should raise an error that the value is unsupported" do
        expect { @k2_segment.to_metro2 }.
            to raise_error(/field purchased_from_sold_to_indicator has unsupported value/)
      end
    end
  end
end
