require 'metro_2/version'

module Metro2

  ALPHANUMERIC = /\A([[:alnum:]]|\s)+\z/
  ALPHANUMERIC_PLUS_DASH = /\A([[:alnum:]]|\s|\-)+\z/
  ALPHANUMERIC_PLUS_DOT_DASH_SLASH = /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/
  NUMERIC = /\A\d+\.?\d*\z/

  FIXED_LENGTH = 426

end

require 'metro_2/fields'
require 'metro_2/metro2_file'

# Require records files
require 'metro_2/records/record'

Dir.new(File.dirname(__FILE__) + '/metro_2/records').each do |file|
  require('metro_2/records/' + File.basename(file)) if File.extname(file) == ".rb"
end


