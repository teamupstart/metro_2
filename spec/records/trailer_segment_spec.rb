require 'spec_helper'

describe Metro2::Records::TrailerSegment do
  before(:each) do
    @trailer = Metro2::Records::TrailerSegment.new
    @trailer.total_base_records = 1
    @trailer.total_status_code_11 = 1
    @trailer.total_social_security_numbers = 1
    @trailer.total_social_security_numbers_in_base = 1
    @trailer.total_date_of_births = 1
    @trailer.total_date_of_births_in_base = 1
    @trailer.total_telephome_numbers = 1
    @trailer.total_k2_segments = 1
  end

  describe '#to_metro2' do
    it 'should generate trailer segment string' do
      exp = [
        '0426',
        'TRAILER',
        '000000001',
        ' ' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '000000001',
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '000000001',
        '0' * 9,
        '0' * 9,
        '0' * 9,
        '000000001',
        '000000001',
        '0' * 9,
        '0' * 9,
        '000000001',
        '000000001',
        '0' * 9,
        '0' * 9,
        '000000001',
        ' ' * 19
      ]
      trailer_str = @trailer.to_metro2
      expect(trailer_str).to eql(exp.join(''))
      expect(trailer_str.size).to eql(Metro2::FIXED_LENGTH)
    end
  end
end
