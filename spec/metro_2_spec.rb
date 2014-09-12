require 'spec_helper'

describe Metro2::Metro2File do

  let(:m2f) { Metro2::Metro2File.new('dummy_content') }

  describe 'alphanumeric_field' do
    it 'should return the input when input is only alphas and equal to max length' do
      expect(m2f.send(:alphanumeric_field, 'header', 6)).to eql('header')
    end

    it 'should return the beginning input when input is only alphas and greater than max length' do
      expect(m2f.send(:alphanumeric_field, 'headerextra', 6)).to eql('header')
    end

    it 'should return the input with trailing spaces when input is only alphas and less than max length' do
      expect(m2f.send(:alphanumeric_field, 'header', 12)).to eql('header      ')
    end

    it 'should return the input when input is only alphanumeric and equal to max length' do
      expect(m2f.send(:alphanumeric_field, 'head12', 6)).to eql('head12')
    end

    it 'should return the beginning input when input is only alphanumeric and greater than max length' do
      expect(m2f.send(:alphanumeric_field, 'head123xtra', 6)).to eql('head12')
    end

    it 'should return the input with trailing spaces when input is only alphanumeric and less than max length' do
      expect(m2f.send(:alphanumeric_field, 'head12', 12)).to eql('head12      ')
    end

    it 'should return the input when input is only alphanumerics with spaces and equal to max length' do
      expect(m2f.send(:alphanumeric_field, 'hea 12', 6)).to eql('hea 12')
    end

    it 'should return all spaces when the input is nil' do
      expect(m2f.send(:alphanumeric_field, nil, 6)).to eql('      ')
    end

    it 'should return all spaces when the input is empty' do
      expect(m2f.send(:alphanumeric_field, '', 6)).to eql('      ')
    end

    it 'should raise an error when input contains symbols' do
      expect{m2f.send(:alphanumeric_field, 'he@der', 6)}.to raise_error(ArgumentError)
    end

    it 'should return the input when input is only alphas and dashes and equal to max length' do
      expect(m2f.send(:alphanumeric_field, 'he-der', 6, Metro2::Metro2File::ALPHANUMERIC_PLUS_DASH)).to eql('he-der')
    end

    it 'should return the input when input is only alphas and dashes and equal to max length' do
      expect(m2f.send(:alphanumeric_field, 'h\/-.r', 6, Metro2::Metro2File::ALPHANUMERIC_PLUS_DOT_DASH_SLASH)).to eql('h\/-.r')
    end
  end

  describe 'numeric_field' do
    it 'should return a string version of the input when input is string numeric and equal to max length' do
      expect(m2f.send(:numeric_field, '123456', 6)).to eql('123456')
    end

    it 'should return a string version of the input when input is numeric and equal to max length' do
      expect(m2f.send(:numeric_field, 123456, 6)).to eql('123456')
    end

    it 'should return a string version of the input rounded down ' +
         'when input is string numeric with a decimal and equal to max length' do
      expect(m2f.send(:numeric_field, '123456.78', 6)).to eql('123456')
    end

    it 'should return a string version of the input rounded down ' +
         'when input is string numeric with a decimal and less than  max length' do
      expect(m2f.send(:numeric_field, '1234.56', 6)).to eql('001234')
    end

    it 'should raise an error ' +
         'when input is string numeric with a decimal and less than  max length' do
      expect{m2f.send(:numeric_field, '12345678.90', 6)}.to raise_error(ArgumentError)
    end

    it 'should return a string version of the input with leading zeros ' +
         'when input is string numeric and less than the max length' do
      expect(m2f.send(:numeric_field, '123456', 12)).to eql('000000123456')
    end

    it 'should return a string version of the input with leading zeros ' +
         'when input is numeric and less than the max length' do
      expect(m2f.send(:numeric_field, 123456, 12)).to eql('000000123456')
    end

    it 'should raise an error when input is larger than the max size' do
      expect{m2f.send(:numeric_field, '1234567', 6)}.to raise_error(ArgumentError)
    end

    it 'should raise an error when input contains alphas' do
      expect{m2f.send(:numeric_field, '12345a', 6)}.to raise_error(ArgumentError)
    end

    it 'should raise an error when input contains symbols' do
      expect{m2f.send(:numeric_field, '12345!', 6)}.to raise_error(ArgumentError)
    end
  end

  describe 'monetary_field' do
    it 'should return a string version of the input when input is string numeric and equal to max length' do
      expect(m2f.send(:monetary_field, '123456', 6)).to eql('123456')
    end

    it 'should return a string version of the input when input is numeric and equal to max length' do
      expect(m2f.send(:monetary_field, 123456, 6)).to eql('123456')
    end

    it 'should return a string version of the input rounded down ' +
         'when input is string numeric with a decimal and equal to max length' do
      expect(m2f.send(:monetary_field, '123456.78', 6)).to eql('123456')
    end

    it 'should return a string version of the input rounded down ' +
         'when input is string numeric with a decimal and less than  max length' do
      expect(m2f.send(:monetary_field, '1234.56', 6)).to eql('001234')
    end

    it 'should raise an error ' +
         'when input is string numeric with a decimal and less than  max length' do
      expect{m2f.send(:monetary_field, '12345678.90', 6)}.to raise_error(ArgumentError)
    end

    it 'should return a string version of the input with leading zeros ' +
         'when input is string numeric and less than the max length' do
      expect(m2f.send(:monetary_field, '123456', 12)).to eql('000000123456')
    end

    it 'should return a string version of the input with leading zeros ' +
         'when input is numeric and less than the max length' do
      expect(m2f.send(:monetary_field, 123456, 12)).to eql('000000123456')
    end

    it 'should raise an error when input is larger than the max size' do
      expect{m2f.send(:monetary_field, '1234567', 6)}.to raise_error(ArgumentError)
    end

    it 'should raise an error when input contains alphas' do
      expect{m2f.send(:monetary_field, '12345a', 6)}.to raise_error(ArgumentError)
    end

    it 'should raise an error when input contains symbols' do
      expect{m2f.send(:monetary_field, '12345!', 6)}.to raise_error(ArgumentError)
    end

    it 'should return all nines when input is greater than one billion' do
      expect(m2f.send(:monetary_field, '1000000001', 9)).to eql('999999999')
    end
  end

end
