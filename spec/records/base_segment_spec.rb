require 'spec_helper'

describe Metro2::Records::BaseSegment do
  before do
    @base = Metro2::Records::BaseSegment.new
    @base.time_stamp = Time.new(2014, 9, 15, 17, 7, 45)
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
    @base.k2_segment = k2_segment
    @base.j2_segment = j2_segment
  end

  let(:k2_segment) { nil }
  let(:j2_segment) { nil }

  context '#to_metro2' do
    let(:expected) do
      [
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
    end

    it 'should generate base segment string' do
      base_str = @base.to_metro2
      expect(base_str).to eql(expected.join(''))
      expect(base_str.size).to eql(Metro2::FIXED_LENGTH)
    end

    context 'with a K2 segment' do
      let(:k2_segment) do
        k2 = Metro2::Records::K2Segment.new
        k2.purchased_from_sold_to_indicator = 9
        k2
      end

      it 'should output the k2 segment in its string and update set_record_descriptor_word' do
        base_str = @base.to_metro2
        expected_length = Metro2::Records::BaseSegment::LENGTH + Metro2::Records::K2Segment::LENGTH
        expect(base_str.size).to eql(expected_length)
        expect(base_str[0..3].to_i).to eql(expected_length)
      end
    end

    context 'with a J2 segment' do
      let(:j2_segment) do
        j2 = Metro2::Records::J2Segment.new
        j2.surname = "Business Name"
        j2.social_security_number = '333224444'
        j2.date_of_birth = Date.new(1987, 4, 19)
        j2.ecoa_code = 'W'
        j2.country_code = 'US'
        j2.address_1 = '742 Evergreen Terrace'
        j2.city = 'Springfield'
        j2.state = 'IL'
        j2.postal_code = '54321'
        j2
      end

      it 'should output the j2 segment in its string and update set_record_descriptor_word' do
        base_str = @base.to_metro2
        expected_length = Metro2::Records::BaseSegment::LENGTH + Metro2::Records::J2Segment::LENGTH
        expect(base_str.size).to eql(expected_length)
        expect(base_str[0..3].to_i).to eql(expected_length)
      end
    end
  end

  context 'alphanumerics' do
    describe 'alphanumeric with symbols' do
      it 'should raise an error' do
        @base.surname = 'B@d name'
        expect{@base.surname_to_metro2}.to raise_error(ArgumentError)
      end
    end

    describe 'alphanumeric with dashes' do
      it 'should not raise an error' do
        @base.surname = 'Name A-ok'
        expect{@base.surname_to_metro2}.not_to raise_error
      end
    end

    describe 'really long alphanumeric' do
      it 'should be truncated' do
        @base.surname = 'Veryveryveryveryverylongname'
        expect(@base.surname_to_metro2).to eql('Veryveryveryveryverylongn')
      end
    end

    describe 'alphanumeric with dots and slashes' do
      it 'should be truncated' do
        @base.address_1 = 'Test Address /1.'
        expect(@base.address_1_to_metro2).to eql('Test Address /1.'.ljust(32, ' '))
      end
    end
  end

  context 'numerics' do
    describe 'numeric with alphas' do
      it 'should raise an error' do
        @base.telephone_number = 'abc5555555'
        expect{@base.telephone_number_to_metro2}.to raise_error(ArgumentError)
      end
    end

    describe 'numeric with symbols' do
      it 'should raise an error' do
        @base.telephone_number = '+555555555'
        expect{@base.telephone_number_to_metro2}.to raise_error(ArgumentError)
      end
    end

    describe 'numeric that is too long' do
      it 'should raise an error' do
        @base.telephone_number = '12345678901'
        expect{@base.telephone_number_to_metro2}.to raise_error(ArgumentError)
      end
    end
  end

  context 'monetary field' do
    describe 'more than one billion' do
      it 'should fill with all 9s' do
        @base.credit_limit = '1000000001'
        expect(@base.credit_limit_to_metro2).to eql('999999999')
      end
    end
  end
end
