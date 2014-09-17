require 'metro_2/version'

module Metro2

  ALPHANUMERIC = /\A([[:alnum:]]|\s)+\z/
  ALPHANUMERIC_PLUS_DASH = /\A([[:alnum:]]|\s|\-)+\z/
  ALPHANUMERIC_PLUS_DOT_DASH_SLASH = /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/
  NUMERIC = /\A\d+\.?\d*\z/

  FIXED_LENGTH = 426

  def self.alphanumeric_to_metro2(val, required_length, permitted_chars)
    # Left justified and blank-filled
    val = val.to_s

    return ' ' * required_length  if val.empty?

    unless !!(val =~ permitted_chars)
      raise ArgumentError.new("Content (#{val}) contains invalid characters")
    end

    if val.size > required_length
      val[0..(required_length-1)]
    else
      val + (' ' * (required_length - val.size))
    end
  end

  def self.numeric_to_metro2(val, required_length, is_monetary)
    # Right justified and zero-filled
    val = val.to_s

    return '0' * required_length if val.empty?

    unless !!(val =~ Metro2::NUMERIC)
      raise ArgumentError.new("field (#{val}) must be numeric")
    end

    decimal_index = val.index('.')
    val = val[0..decimal_index-1] if decimal_index

    return '9' * required_length if is_monetary && val.to_f >= 1000000000
    if val.size > required_length
      raise ArgumentError.new("numeric field (#{val}) is too long (max #{required_length})")
    end

    ('0' * (required_length - val.size)) + val
  end
end

require 'metro_2/fields'
require 'metro_2/metro2_file'

# Require records files
require 'metro_2/records/record'

Dir.new(File.dirname(__FILE__) + '/metro_2/records').each do |file|
  require('metro_2/records/' + File.basename(file)) if File.extname(file) == ".rb"
end
