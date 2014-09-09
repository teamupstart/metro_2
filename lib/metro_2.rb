require "metro_2/version"
require "date"

module Metro2
  class File
    def initialize(file_contents)
      @file_contents = file_contents
    end

    def header
      if @file_contents.header.respond_to?(:activity_date)
        activity_date = @file_contents.header.activity_date
      else
        activity_date = Date.today.strftime('%m%d%Y')
      end
      if @file_contents.header.respond_to?(:created_date)
        created_date = @file_contents.header.created_date
      else
        created_date = Date.today.strftime('%m%d%Y')
      end

      # Block Descriptor Word not used when reporting fixed length records
      numeric_field(@file_contents.records.size.to_s, 4) + # record descriptor word
      alphanumeric_field('HEADER', 6) + # record identifier
      alphanumeric_field(@file_contents.header.cycle_number.to_s, 2) + # cycle number
      alphanumeric_field(@file_contents.header.innovis_program_identifier, 10) + # Innovis program identfier
      alphanumeric_field(@file_contents.header.equifax_program_identifier, 10) + # Equifax program identfier
      alphanumeric_field(@file_contents.header.experian_program_identifier, 5) + # Experian program identfier
      alphanumeric_field(@file_contents.header.transunion_program_identifier, 10) + # Transunion program identfier
      numeric_field(activity_date, 8) + # Activity date
      numeric_field(created_date, 8) + # Date created
      numeric_field(@file_contents.header.program_date, 8) + # Program date
      numeric_field(@file_contents.header.program_revision_date || '01', 8) + # Program revision date
      alphanumeric_field(@file_contents.header.reporter_name, 40) + # Reporter name
      alphanumeric_field(@file_contents.header.reporter_address, 96) + # Reporter address
      numeric_field(@file_contents.header.reporter_telephone_number, 10) + # Reporter telephone number
      alphanumeric_field(@file_contents.header.software_vendor_name, 40) + # Software vendor name
      alphanumeric_field(@file_contents.header.software_version_number, 5) + # Software vendor name
      alphanumeric_field(nil, 156) # reserved - blank fill
    end

    private

    def alphanumeric_field(field_contents, required_length)
      unless !!(field_contents =~ /\A([[:alnum:]]|\s)+\z/x) # must be alphanumeric (spaces ok)
        raise ArgumentError.new("Content must be alphanumeric (#{field_contents})")
      end

      return ' ' * required_length  unless field_contents

      # Left justified and blank-filled
      if field_contents.size > required_length
        field_contents[0..(required_length-1)]
      else
        field_contents + (' ' * (required_length - field_contents.size))
      end
    end

    def numeric_field(field_contents, required_length)
      # Right justified and zero-filled
      return '0' * required_length unless field_contents

      unless is_numeric?(field_contents)
        raise ArgumentError.new("field (#{field_contents}) must be numeric")
      end

      if field_contents.size > required_length
        raise ArgumentError.new("numeric field (#{field_contents}) is too long (max #{required_length})")
      end

      ('0' * (required_length - field_contents.size)) + field_contents.to_s
    end

    def monetary_field(field_contents, required_length)
      # Nine filled if value is greater than 1 billion
      return '9' * required_length if field_contents > 1000000000

      numeric_field(field_contents, required_length)
    end

    def is_numeric?(str)
      true if Float(str) rescue false
    end
  end
end
