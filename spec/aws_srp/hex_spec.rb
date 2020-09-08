# frozen_string_literal: true

RSpec.describe AwsSRP::Hex do
  describe '.str' do
    it 'return a hex string' do
      expect(described_class.str('aa')).to eql ['aa'].pack('H*')
    end
  end

  describe 'initialization' do
    it 'raises an error if the given string is not a hex string' do
      expect { described_class.new('XX') }.to raise_error ArgumentError
    end

    it 'accepts a string' do
      hex = described_class.new('aa')

      expect(hex.str).to eql 'aa'
    end

    it 'downcases a string' do
      hex = described_class.new('AA')

      expect(hex.str).to eql 'aa'
    end

    it 'accepts an integer' do
      hex = described_class.new(10)

      expect(hex.str).to eql 'a'
      expect(hex.int).to eql 10
    end
  end

  describe '#int/#to_i' do
    it 'returns an interger as base 16' do
      hex = described_class.new('a')

      expect(hex.int).to eql 10
      expect(hex.to_i).to eql 10
    end
  end

  describe '#padding' do
    it 'returns 0 when the length is odd' do
      hex = described_class.new('a')

      expect(hex.padding).to eql '0'
    end

    it 'returns 00 when the given string starts with certain symbols' do
      %w[a b c d e f 8 9].each do |prefix|
        hex = described_class.new("#{prefix}a")
        expect(hex.padding).to eql '00'
      end
    end
  end

  describe '#to_s' do
    it 'returns an ASCII hex predended with the padding' do
      hex = described_class.new('AA')

      expect(hex.to_s).to eql '00aa'
    end
  end

  describe '#to_hs' do
    it 'returns a hex string representation of the padded string' do
      hex = described_class.new('AA')

      expect(hex.to_hs).to eql ['00aa'].pack('H*')
    end
  end

  describe '#concat' do
    it 'concatenates the given string with the padded string' do
      hex = described_class.new('aa')

      expect(hex.concat('bb')).to eql '00aabb'
    end

    it 'forces the other argument to be a padded string if it is a hex' do
      hex1 = described_class.new('aa')
      hex2 = described_class.new('bb')

      expect(hex1.concat(hex2)).to eql '00aa00bb'
    end
  end

  describe 'arithmetic_operators' do
    described_class::ARITHMETIC_OPERATORS.each do |method|
      describe "#{method}" do
        let(:hex1) { described_class.new('a') }
        let(:hex2) { described_class.new('b') }

        it 'performs the operation on the int and wraps the result in a hex' do
          result = hex1.public_send(method, 2)

          expect(result).to be_kind_of described_class
          expect(result.int).to eql hex1.int.public_send(method, 2)
        end

        it 'supports a hex argument' do
          result = hex1.public_send(method, hex2)

          expect(result).to be_kind_of described_class
          expect(result.int).to eql hex1.int.public_send(method, hex2.int)
        end
      end
    end
  end

  describe '#zero?' do
    it 'returns true if hex has a zero value' do
      expect(described_class.new('0')).to be_zero
      expect(described_class.new('a')).not_to be_zero
    end
  end

  describe '#mod_exp' do
    let(:hex1) { described_class.new('aaaa') }
    let(:hex2) { described_class.new('bbbb') }
    let(:hex3) { described_class.new('cccc') }

    it 'does (a**b) % m on the int value and wraps the result in a hex' do
      result = hex1.mod_exp(2323, 1212)

      expect(result).to be_kind_of described_class
      expect(result.int).to eql hex1.int.pow(2323, 1212)
    end

    it 'supports hex arguments' do
      result = hex1.mod_exp(hex2, hex3)

      expect(result).to be_kind_of described_class
      expect(result.int).to eql hex1.int.pow(hex2.int, hex3.int)
    end
  end
end
