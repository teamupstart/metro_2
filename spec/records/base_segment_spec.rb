require 'spec_helper'

describe Metro2::Records::BaseSegment do
  before(:each) do
    @base = Metro2::Records::BaseSegment.new
    @base.time_stamp = Time.new(2014, 9, 15, 17, 7, 45).strftime('%m%d%Y%H%M%S')
    @base.identification_number = 'REPORTERXYZ'
    @base.cycle_number = 1
    @base.consumer_account_number = 'ABC123'
    @base.portfolio_type = 'I'
    @base.account_type = '01'
    @base.date_opened = Date.new(2013, 4, 1)
    @base.highest_credit_or_loan_amount = 25000
    @base.terms_duration = 36
    @base.terms_frequency = 'M'
    @base.scheduled_monthly_payment_amount = 817.8
    @base.actual_payment_amount = 817.8
    @base.account_status = '11'
    @base.payment_history_profile = '00000000000000000BBBBBBB'
    @base.current_balance = 11111
    @base.account_information_date = Date.new(2014, 9, 1)
    @base.last_payment_date = Date.new(2014, 8, 1)
    @base.interest_type_indicator = 'F'
    @base.surname = 'Simpson'
    @base.first_name = 'Homer'
    @base.middle_name = 'Jay'
    @base.social_security_number = '333224444'
    @base.date_of_birth = Date.new(1987, 4, 19)
    @base.telephone_number = '5555555555'
    @base.ecoa_code = 1
    @base.country_code = 'US'
    @base.address_1 = '742 Evergreen Terrace'
    @base.city = 'Springfield'
    @base.state = 'IL'
    @base.postal_code = '54321'
    @base.address_indicator = 'N'
    @base.residence_code = 'O'
  end

  describe '#to_metro2' do
    it 'should generate base segment string' do
      exp = [
        '0426',
        '1',
        '09152014170745',
        '0',
        'REPORTERXYZ'.ljust(20, ' '),
        '1 ',
        'ABC123'.ljust(30, ' '),
        'I',
        '01',
        '04012013',
        '0' * 9,
        '000025000',
        '36 ',
        'M',
        '000000817',
        '000000817',
        '11',
        ' ',
        '00000000000000000BBBBBBB',
        '  ',
        '  ',
        '000011111',
        '000000000',
        '000000000',
        '09012014',
        '00000000',
        '00000000',
        '08012014',
        'F',
        ' ' * 16,
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
        ''
      ]
      base_str = @base.to_metro2
      expect(base_str).to eql(exp.join(''))
      expect(base_str.size).to eql(Metro2::FIXED_LENGTH)
    end
  end
end
