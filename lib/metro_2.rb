require "metro_2/version"

module Metro2

  require 'metro_2/fields'
  require 'metro_2/version'

# Require records files
  require 'metro_2/records/record'

  Dir.new(File.dirname(__FILE__) + '/metro_2/records').each do |file|
    require('metro_2/records/' + File.basename(file)) if File.extname(file) == ".rb"
  end

  # class Metro2File
  #
  #   FIXED_LENGTH = 426
  #
  #   ALPHANUMERIC = 0
  #   ALPHANUMERIC_PLUS_DASH = 1
  #   ALPHANUMERIC_PLUS_DOT_DASH_SLASH = 2
  #
  #
  #   def initialize(file_contents)
  #     @file_contents = file_contents
  #     @status_code_count = Hash.new(0)
  #     @ecoa_code_count = Hash.new(0)
  #     @num_ssn = 0
  #     @num_dob = 0
  #     @num_telephone = 0
  #   end
  #
  #   def header
  #     header_contents = @file_contents.header
  #     contents = []
  #
  #     # Block Descriptor Word not used when reporting fixed length records
  #     contents << numeric_field(FIXED_LENGTH, 4) # record descriptor word
  #     contents << alphanumeric_field('HEADER', 6) # record identifier
  #     contents << alphanumeric_field(header_contents.cycle_number, 2)
  #     contents << alphanumeric_field(header_contents.innovis_program_identifier, 10)
  #     contents << alphanumeric_field(header_contents.equifax_program_identifier, 10)
  #     contents << alphanumeric_field(header_contents.experian_program_identifier, 5)
  #     contents << alphanumeric_field(header_contents.transunion_program_identifier, 10)
  #     contents << date_field(header_contents.activity_date)
  #     contents << date_field(header_contents.created_date)
  #     contents << date_field(header_contents.program_date)
  #     contents << numeric_field(program_revision_date, 8)
  #     contents << alphanumeric_field(header_contents.reporter_name, 40)
  #     contents << alphanumeric_field(header_contents.reporter_address, 96)
  #     contents << numeric_field(header_contents.reporter_telephone_number, 10)
  #     contents << alphanumeric_field(header_contents.software_vendor_name, 40)
  #     contents << alphanumeric_field(header_contents.software_version_number, 5)
  #     contents << alphanumeric_field(nil, 156) # reserved - blank fill
  #     contents.join
  #   end
  #
  #   def records
  #     records = @file_contents.records
  #
  #     records.map { |r| record(r) }.join('\n')
  #   end
  #
  #   def trailer
  #     contents = []
  #
  #     contents << numeric_field(FIXED_LENGTH, 4) # record descriptor word
  #     contents << alphanumeric_field('TRAILER', 7) # record identifier
  #     contents << numeric_field(@file_contents.records.size, 9) # total base records
  #     contents << alphanumeric_field(nil, 9) # reserved
  #     contents << numeric_field(@status_code_count['DF'], 9)
  #     contents << numeric_field(nil, 9) # J1 Segments not currently supported
  #     contents << numeric_field(nil, 9) # J2 Segments not currently supported
  #     contents << numeric_field(nil, 9) # block count not applicable
  #     contents << numeric_field(@status_code_count['DA'], 9)
  #     contents << numeric_field(@status_code_count['05'], 9)
  #     contents << numeric_field(@status_code_count['11'], 9)
  #     contents << numeric_field(@status_code_count['13'], 9)
  #     contents << numeric_field(@status_code_count['61'], 9)
  #     contents << numeric_field(@status_code_count['62'], 9)
  #     contents << numeric_field(@status_code_count['63'], 9)
  #     contents << numeric_field(@status_code_count['64'], 9)
  #     contents << numeric_field(@status_code_count['65'], 9)
  #     contents << numeric_field(@status_code_count['71'], 9)
  #     contents << numeric_field(@status_code_count['78'], 9)
  #     contents << numeric_field(@status_code_count['80'], 9)
  #     contents << numeric_field(@status_code_count['82'], 9)
  #     contents << numeric_field(@status_code_count['83'], 9)
  #     contents << numeric_field(@status_code_count['84'], 9)
  #     contents << numeric_field(@status_code_count['88'], 9)
  #     contents << numeric_field(@status_code_count['89'], 9)
  #     contents << numeric_field(@status_code_count['93'], 9)
  #     contents << numeric_field(@status_code_count['94'], 9)
  #     contents << numeric_field(@status_code_count['95'], 9)
  #     contents << numeric_field(@status_code_count['96'], 9)
  #     contents << numeric_field(@status_code_count['97'], 9)
  #     contents << numeric_field(@ecoa_code_count['Z'], 9)
  #     contents << numeric_field(nil, 9) # N1 Segments not currently supported
  #     contents << numeric_field(nil, 9) # K1 Segments not currently supported
  #     contents << numeric_field(nil, 9) # K2 Segments not currently supported
  #     contents << numeric_field(nil, 9) # K3 Segments not currently supported
  #     contents << numeric_field(nil, 9) # K4 Segments not currently supported
  #     contents << numeric_field(nil, 9) # L1 Segments not currently supported
  #     contents << numeric_field(@num_ssn, 9) # Total SSNs
  #     contents << numeric_field(@num_ssn, 9) # Total SSNs in Base Segments (same as above since other segments are not supported)
  #     contents << numeric_field(nil, 9) # J1 Segments not currently supported
  #     contents << numeric_field(nil, 9) # J2 Segments not currently supported
  #     contents << numeric_field(@num_dob, 9) # Total DoBs
  #     contents << numeric_field(@num_dob, 9) # Total DoBs in Base Segments (same as above since other segments are not supported)
  #     contents << numeric_field(nil, 9) # J1 Segments not currently supported
  #     contents << numeric_field(nil, 9) # J2 Segments not currently supported
  #     contents << numeric_field(@num_telephone, 9) # Total Telephone numbers
  #     contents << numeric_field(nil, 19) # reserved
  #     contents.join
  #   end
  #
  #   private
  #
  #   def record(record_contents)
  #     contents = []
  #
  #     account_status = record_contents.account_status
  #     @status_code_count[account_status] += 1 # track count of each status
  #     ssn = record_contents.social_security_number
  #     @num_ssn += 1 unless ssn == '999999999' # track count of SSNs
  #     dob = record_contents.date_of_birth
  #     @num_dob += 1 if dob # track count of DoBs
  #     telephone_number = record_contents.telephone_number
  #     @num_telephone += 1 if telephone_number == '9999999999' # track count of telephone numbers
  #
  #     # Block Descriptor Word not used when reporting fixed length records
  #     contents << numeric_field(FIXED_LENGTH, 4) # record descriptor word
  #     contents << alphanumeric_field(1, 1) # processing indicator (always 1)
  #     contents << numeric_field(record_contents.time_stamp.strftime('%m%d%Y%H%M%S'), 14)
  #     contents << alphanumeric_field(record_contents.correction_indicator, 1)
  #     contents << alphanumeric_field(record_contents.identification_number, 20)
  #     contents << alphanumeric_field(record_contents.cycle_number, 2)
  #     contents << alphanumeric_field(record_contents.consumer_account_number, 30)
  #     contents << alphanumeric_field(record_contents.portfolio_type, 1)
  #     contents << alphanumeric_field(record_contents.account_type, 2)
  #     contents << date_field(record_contents.date_opened)
  #     contents << monetary_field(record_contents.credit_limit)
  #     contents << monetary_field(record_contents.highest_credit_or_loan_amount)
  #     contents << alphanumeric_field(record_contents.terms_duration, 3)
  #     contents << alphanumeric_field(record_contents.terms_frequency, 1)
  #     contents << monetary_field(record_contents.scheduled_monthly_payment_amount)
  #     contents << monetary_field(record_contents.actual_payment_amount)
  #     contents << alphanumeric_field(account_status, 2)
  #     contents << alphanumeric_field(record_contents.payment_rating, 1)
  #     contents << alphanumeric_field(record_contents.payment_history_profile, 24)
  #     contents << alphanumeric_field(record_contents.special_comment, 2)
  #     contents << alphanumeric_field(record_contents.compliance_condition_code, 2)
  #     contents << monetary_field(record_contents.current_balance)
  #     contents << monetary_field(record_contents.amount_past_due)
  #     contents << monetary_field(record_contents.original_charge_off_amount)
  #     contents << date_field(record_contents.account_information_date)
  #     contents << date_field(record_contents.first_delinquency_date)
  #     contents << date_field(record_contents.closed_date)
  #     contents << date_field(record_contents.last_payment_date)
  #     contents << alphanumeric_field(record_contents.interest_type_indicator, 1)
  #     contents << alphanumeric_field(nil, 16) # reserved - blank fill
  #     contents << alphanumeric_field(record_contents.consumer_transaction_type, 1)
  #     contents << alphanumeric_field(record_contents.surname, 25, ALPHANUMERIC_PLUS_DASH)
  #     contents << alphanumeric_field(record_contents.first_name, 20, ALPHANUMERIC_PLUS_DASH)
  #     contents << alphanumeric_field(record_contents.middle_name, 20, ALPHANUMERIC_PLUS_DASH)
  #     contents << alphanumeric_field(record_contents.generation_code, 1)
  #     contents << numeric_field(ssn, 9)
  #     contents << date_field(dob)
  #     contents << numeric_field(telephone_number, 10)
  #     contents << alphanumeric_field(record_contents.ecoa_code, 1)
  #     contents << alphanumeric_field(record_contents.consumer_information_indicator, 2)
  #     contents << alphanumeric_field(record_contents.country_code, 2)
  #     contents << alphanumeric_field(record_contents.address_1, 32, ALPHANUMERIC_PLUS_DOT_DASH_SLASH)
  #     contents << alphanumeric_field(record_contents.address_2, 32, ALPHANUMERIC_PLUS_DOT_DASH_SLASH)
  #     contents << alphanumeric_field(record_contents.city, 20)
  #     contents << alphanumeric_field(record_contents.state, 2)
  #     contents << alphanumeric_field(record_contents.postal_code, 9)
  #     contents << alphanumeric_field(record_contents.address_indicator, 1)
  #     contents << alphanumeric_field(record_contents.residence_code, 1)
  #     contents.join
  #   end
  #
  #   def program_revision_date
  #     # Program revision date (01 if not modified)
  #     revision_date = @file_contents.header.program_revision_date
  #     if revision_date
  #       revision_date.strftime('%m%d%Y')
  #     else
  #       '01'
  #     end
  #   end
  #
  #   def alphanumeric_field(field_contents, required_length, permitted_chars = ALPHANUMERIC)
  #     # Left justified and blank-filled
  #     field_contents = field_contents.to_s
  #
  #     return ' ' * required_length  if field_contents.empty?
  #
  #     unless has_correct_characters?(field_contents, permitted_chars)
  #       raise ArgumentError.new("Content (#{field_contents}) contains invalid characters")
  #     end
  #
  #     if field_contents.size > required_length
  #       field_contents[0..(required_length-1)]
  #     else
  #       field_contents + (' ' * (required_length - field_contents.size))
  #     end
  #   end
  #
  #   def numeric_field(field_contents, required_length, is_monetary_field=false)
  #     # Right justified and zero-filled
  #     field_contents = field_contents.to_s
  #
  #     return '0' * required_length if field_contents.empty?
  #
  #     unless is_numeric?(field_contents)
  #       raise ArgumentError.new("field (#{field_contents}) must be numeric")
  #     end
  #
  #     decimal_index = field_contents.index('.')
  #     field_contents = field_contents[0..decimal_index-1] if decimal_index
  #
  #     return '9' * required_length if is_monetary_field && field_contents.to_f >= 1000000000
  #     if field_contents.size > required_length
  #       raise ArgumentError.new("numeric field (#{field_contents}) is too long (max #{required_length})")
  #     end
  #
  #     ('0' * (required_length - field_contents.size)) + field_contents
  #   end
  #
  #   def monetary_field(field_contents)
  #     numeric_field(field_contents, 9, true)
  #   end
  #
  #   def date_field(field_contents)
  #     field_contents = field_contents.strftime('%m%d%Y') if field_contents
  #     numeric_field(field_contents, 8, true)
  #   end
  #
  #   def is_numeric?(str)
  #     !!(str =~ /\A\d+\.?\d*\z/)
  #   end
  #
  #   def has_correct_characters?(str, permitted_chars)
  #     case permitted_chars
  #     when ALPHANUMERIC
  #       # must be alphanumeric with spaces
  #       !!(str =~ /\A([[:alnum:]]|\s)+\z/)
  #     when ALPHANUMERIC_PLUS_DASH
  #       !!(str =~ /\A([[:alnum:]]|\s|\-)+\z/)
  #     when ALPHANUMERIC_PLUS_DOT_DASH_SLASH
  #       !!(str =~ /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/)
  #     else
  #       raise ArgumentError.new("unknown permitted character type (#{permitted_chars})")
  #     end
  #   end
  # end
end
