module Metro2::Records
  class HeaderSegment < Record
    @fields = []

    numeric_const_field :record_descriptor_word, 4, Metro2::FIXED_LENGTH
    alphanumeric_const_field :record_identifier, 6, 'HEADER'
    alphanumeric_field :cycle_number, 2
    alphanumeric_field :innovis_program_identifier, 10
    alphanumeric_field :equifax_program_identifier, 10
    alphanumeric_field :experian_program_identifier, 5
    alphanumeric_field :transunion_program_identifier, 10
    date_field :activity_date
    date_field :created_date
    date_field :program_date
    numeric_field :program_revision_date, 8
    alphanumeric_field :reporter_name, 40
    alphanumeric_field :reporter_address, 96, Metro2::ALPHANUMERIC_PLUS_DOT_DASH_SLASH
    numeric_field :reporter_telephone_number, 10
    alphanumeric_field :software_vendor_name, 40
    alphanumeric_field :software_version_number, 5
    alphanumeric_const_field :reserved, 156, nil
  end
end
