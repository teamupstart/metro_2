require "metro_2/version"
require "date"

module Metro2
  class File
    def initialize(file_contents)
      @file_contents = file_contents
    end

    def header
      contents = []

      # Block Descriptor Word not used when reporting fixed length records
      contents << numeric_field(@file_contents.records.size.to_s, 4) # record descriptor word
      contents << alphanumeric_field('HEADER', 6) # record identifier
      contents << alphanumeric_field(@file_contents.header.cycle_number.to_s, 2) # cycle number
      contents << alphanumeric_field(@file_contents.header.innovis_program_identifier, 10) # Innovis program identfier
      contents << alphanumeric_field(@file_contents.header.equifax_program_identifier, 10) # Equifax program identfier
      contents << alphanumeric_field(@file_contents.header.experian_program_identifier, 5) # Experian program identfier
      contents << alphanumeric_field(@file_contents.header.transunion_program_identifier, 10) # Transunion program identfier
      contents << numeric_field(@file_contents.header.activity_date.strftime('%m%d%Y'), 8) # Activity date
      contents << numeric_field(@file_contents.header.created_date.strftime('%m%d%Y'), 8) # Date created
      contents << numeric_field(@file_contents.header.program_date.strftime('%m%d%Y'), 8) # Program date
      contents << numeric_field(program_revision_date, 8)
      contents << alphanumeric_field(@file_contents.header.reporter_name, 40) # Reporter name
      contents << alphanumeric_field(@file_contents.header.reporter_address, 96) # Reporter address
      contents << numeric_field(@file_contents.header.reporter_telephone_number, 10) # Reporter telephone number
      contents << alphanumeric_field(@file_contents.header.software_vendor_name, 40) # Software vendor name
      contents << alphanumeric_field(@file_contents.header.software_version_number, 5) # Software vendor name
      contents << alphanumeric_field(nil, 156) # reserved - blank fill
      contents.join
    end

    private

    def program_revision_date
      # Program revision date (01 if not modified)
      if @file_contents.header.program_revision_date
        @file_contents.header.program_revision_date.strftime('%m%d%Y')
      else
        '01'
      end
    end

    def alphanumeric_field(field_contents, required_length)
      # must be alphanumeric (spaces ok)
      unless field_contents.blank? || !!(field_contents =~ /\A([[:alnum:]]|\s)+\z/x)
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
