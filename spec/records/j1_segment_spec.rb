require 'spec_helper'

describe Metro2::Records::J1Segment do
  before do
    @j1 = described_class.new
    @j1.surname = 'Simpson'
    @j1.first_name = 'Homer'
    @j1.middle_name = 'Jay'
    @j1.social_security_number = '333224444'
    @j1.date_of_birth = Date.new(1987, 4, 19)
    @j1.telephone_number = '5555555555'
    @j1.ecoa_code = 1
  end

  context '#to_metro2' do
    it 'should generate j1 segment string' do
      exp = [
        'J1',
        ' ',
        'Simpson'.ljust(25, ' '),
        'Homer'.ljust(20, ' '),
        'Jay'.ljust(20, ' '),
        ' ',
        '333224444',
        '04191987',
        '5555555555',
        '1',
        '  ',
        ' '
      ]

      j1_str = @j1.to_metro2
      expect(j1_str).to eq(exp.join(''))
    end
  end
end
