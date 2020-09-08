# frozen_string_literal: true

module AwsSRP
  # Hexadecimal number represntation.
  class Hex
    HEX_STRING_PATTERN = /^[a-fA-F0-9]+$/.freeze
    DOUBLE_ZERO_PADDING_PATTERN = /^[a-fA-F89]/.freeze
    ARITHMETIC_OPERATORS = %i[+ - * / %].freeze

    # Return a hex string (e.g. \x9F)
    def self.str(str)
      [str].pack('H*')
    end

    attr_reader :str

    def initialize(val)
      @str, @int = if val.is_a?(Integer)
        [val.to_s(16), val]
      else
        validate_str!(val.to_s)
      end

      @str = @str.downcase
    end

    def int
      @int ||= str.hex
    end
    alias to_i int

    def padding
      if str.length.odd?
        '0'
      elsif str =~ DOUBLE_ZERO_PADDING_PATTERN
        '00'
      end
    end

    def to_s
      "#{padding}#{str}"
    end

    # to hex string (e.g. \x9F)
    def to_hs
      self.class.str(to_s)
    end

    def concat(other)
      to_s + other.to_s
    end

    ARITHMETIC_OPERATORS.each do |method|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{method}(other)
          self.class.new(to_i.#{method}(other.to_i))
        end
      CODE
    end

    def zero?
      to_i.zero?
    end

    def mod_exp(b, m)
      self.class.new(_mod_exp(to_i, b.to_i, m.to_i))
    end

    private

    def validate_str!(val)
      return val if val =~ HEX_STRING_PATTERN

      raise ArgumentError, "'#{val}' must be a hex string"
    end

    # Modular Exponentiation
    # https://en.wikipedia.org/wiki/Modular_exponentiation
    # http://rosettacode.org/wiki/Modular_exponentiation#Ruby
    if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5')
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def _mod_exp(a, b, m)
          a.to_bn.mod_exp(b, m).to_i
        end
      CODE
    else
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def _mod_exp(a, b, m)
          a.pow(b, m)
        end
      CODE
    end
  end
end
