require 'spec_helper'

describe Metro2::Records::J2Segment do
  before do
    @j2 = described_class.new
    @j2.surname = 'Simpson'
    @j2.first_name = 'Homer'
    @j2.middle_name = 'Jay'
    @j2.social_security_number = '333224444'
    @j2.date_of_birth = Date.new(1987, 4, 19)
    @j2.telephone_number = '5555555555'
    @j2.ecoa_code = 1
    @j2.country_code = 'US'
    @j2.address_1 = '742 Evergreen Terrace'
    @j2.city = 'Springfield'
    @j2.state = 'IL'
    @j2.postal_code = '54321'
    @j2.address_indicator = 'N'
    @j2.residence_code = 'O'
  end

  context '#to_metro2' do
    it 'should generate j1 segment string' do
      exp = [
        'J2',
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
        'US',
        '742 Evergreen Terrace'.ljust(32, ' '),
        ' ' * 32,
        'Springfield'.ljust(20, ' '),
        'IL',
        '54321    ',
        'N',
        'O',
        '  '
      ]

      j2_str = @j2.to_metro2
      expect(j2_str).to eq(exp.join(''))
    end
  end
end
