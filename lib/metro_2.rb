require "metro_2/version"

module Metro2
  class Metro2File
    def initialize(file_contents)
      @file_contents = file_contents
    end

    def header
      header_contents = @file_contents.header
      contents = []

      # Block Descriptor Word not used when reporting fixed length records
      contents << numeric_field(@file_contents.records.size.to_s, 4) # record descriptor word
      contents << alphanumeric_field('HEADER', 6) # record identifier
      contents << alphanumeric_field(header_contents.cycle_number.to_s, 2) # cycle number
      contents << alphanumeric_field(header_contents.innovis_program_identifier, 10) # Innovis program identfier
      contents << alphanumeric_field(header_contents.equifax_program_identifier, 10) # Equifax program identfier
      contents << alphanumeric_field(header_contents.experian_program_identifier, 5) # Experian program identfier
      contents << alphanumeric_field(header_contents.transunion_program_identifier, 10) # Transunion program identfier
      contents << numeric_field(header_contents.activity_date.strftime('%m%d%Y'), 8) # Activity date
      contents << numeric_field(header_contents.created_date.strftime('%m%d%Y'), 8) # Date created
      contents << numeric_field(header_contents.program_date.strftime('%m%d%Y'), 8) # Program date
      contents << numeric_field(program_revision_date, 8)
      contents << alphanumeric_field(header_contents.reporter_name, 40) # Reporter name
      contents << alphanumeric_field(header_contents.reporter_address, 96) # Reporter address
      contents << numeric_field(header_contents.reporter_telephone_number, 10) # Reporter telephone number
      contents << alphanumeric_field(header_contents.software_vendor_name, 40) # Software vendor name
      contents << alphanumeric_field(header_contents.software_version_number, 5) # Software vendor name
      contents << alphanumeric_field(nil, 156) # reserved - blank fill
      contents.join
    end

    private

    def program_revision_date
      # Program revision date (01 if not modified)
      revision_date = @file_contents.header.program_revision_date
      if revision_date
        revision_date.strftime('%m%d%Y')
      else
        '01'
      end
    end

    def alphanumeric_field(field_contents, required_length)
      # Left justified and blank-filled
      field_contents = field_contents.to_s

      return ' ' * required_length  if field_contents.empty?

      # must be alphanumeric (spaces ok)
      unless is_alphanumeric?(field_contents)
        raise ArgumentError.new("Content must be alphanumeric (#{field_contents})")
      end

      if field_contents.size > required_length
        field_contents[0..(required_length-1)]
      else
        field_contents + (' ' * (required_length - field_contents.size))
      end
    end

    def numeric_field(field_contents, required_length, is_monetary_field=false)
      # Right justified and zero-filled
      field_contents = field_contents.to_s

      return '0' * required_length if field_contents.empty?

      unless is_numeric?(field_contents)
        raise ArgumentError.new("field (#{field_contents}) must be numeric")
      end

      decimal_index = field_contents.index('.')
      field_contents = field_contents[0..decimal_index-1] if decimal_index

      return '9' * required_length if is_monetary_field && field_contents.to_f >= 1000000000
      if field_contents.size > required_length
        raise ArgumentError.new("numeric field (#{field_contents}) is too long (max #{required_length})")
      end

      ('0' * (required_length - field_contents.size)) + field_contents
    end

    def monetary_field(field_contents, required_length)
      numeric_field(field_contents, required_length, true)
    end

    def is_numeric?(str)
      !!(str =~ /\A\d+\.?\d*\z/)
    end

    def is_alphanumeric?(str)
      !!(str =~ /\A([[:alnum:]]|\s)+\z/x)
    end
  end
end
