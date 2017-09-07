require 'spec_helper'

describe Metro2::Records::HeaderSegment do
  before(:each) do
    @header = Metro2::Records::HeaderSegment.new
    @header.cycle_number = 15
    @header.equifax_program_identifier = 'EFAXID'
    @header.transunion_program_identifier = 'TRANSUNION'
    @header.activity_date = Date.new(2014,9,14)
    @header.created_date = Date.new(2014,9,15)
    @header.program_date = Date.new(2014,9,1)
    @header.reporter_name = 'Credit Reporter'
    @header.reporter_address = '123 Report Dr Address CA 91111'
    @header.reporter_telephone_number = '5555555555'
  end

  describe '#to_metro2' do
    it 'should generate header segment string' do
      exp = [
        '0426',
        'HEADER',
        '15',
        '          ',
        'EFAXID    ',
        '     ',
        'TRANSUNION',
        '09142014',
        '09152014',
        '09012014',
        '00000000',
        'Credit Reporter'.ljust(40, ' '),
        '123 Report Dr Address CA 91111'.ljust(96, ' '),
        '5555555555',
        'Upstart Engineer metro 2 gem'.ljust(40, ' '),
        '01108',
        ' ' * 156
      ]
      header_str = @header.to_metro2
      expect(header_str).to eql(exp.join(''))
      expect(header_str.size).to eql(Metro2::FIXED_LENGTH)
    end
  end
end
