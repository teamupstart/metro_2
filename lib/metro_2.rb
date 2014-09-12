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
      contents << numeric_field(426, 4) # record descriptor word
      contents << alphanumeric_field('HEADER', 6) # record identifier
      contents << alphanumeric_field(header_contents.cycle_number, 2)
      contents << alphanumeric_field(header_contents.innovis_program_identifier, 10)
      contents << alphanumeric_field(header_contents.equifax_program_identifier, 10)
      contents << alphanumeric_field(header_contents.experian_program_identifier, 5)
      contents << alphanumeric_field(header_contents.transunion_program_identifier, 10)
      contents << numeric_field(header_contents.activity_date.strftime('%m%d%Y'), 8)
      contents << numeric_field(header_contents.created_date.strftime('%m%d%Y'), 8)
      contents << numeric_field(header_contents.program_date.strftime('%m%d%Y'), 8)
      contents << numeric_field(program_revision_date, 8)
      contents << alphanumeric_field(header_contents.reporter_name, 40)
      contents << alphanumeric_field(header_contents.reporter_address, 96)
      contents << numeric_field(header_contents.reporter_telephone_number, 10)
      contents << alphanumeric_field(header_contents.software_vendor_name, 40)
      contents << alphanumeric_field(header_contents.software_version_number, 5)
      contents << alphanumeric_field(nil, 156) # reserved - blank fill
      contents.join
    end

    def records
      records = @file_contents.records

      records.map{ |r| record(r) }.join('\n')
    end

    private

    ALPHANUMERIC = 0
    ALPHANUMERIC_PLUS_DASH = 1
    ALPHANUMERIC_PLUS_DOT_DASH_SLASH = 2

    def record(record_contents)
      contents = []

      # Block Descriptor Word not used when reporting fixed length records
      contents << numeric_field(426, 4) # record descriptor word
      contents << alphanumeric_field(1, 1) # processing indicator (always 1)
      contents << numeric_field(record_contents.time_stamp.strftime('%m%d%Y%H%M%S'), 14)
      contents << alphanumeric_field(record_contents.correction_indicator, 1)
      contents << alphanumeric_field(record_contents.identification_number, 20)
      contents << alphanumeric_field(record_contents.cycle_number, 2)
      contents << alphanumeric_field(record_contents.consumer_account_number, 30)
      contents << alphanumeric_field(record_contents.portfolio_type, 1)
      contents << alphanumeric_field(record_contents.account_type, 2)
      contents << date_field(record_contents.date_opened, 8)
      contents << numeric_field(record_contents.credit_limit, 9)
      contents << numeric_field(record_contents.highest_credit_or_loan_amount, 9)
      contents << alphanumeric_field(record_contents.terms_duration, 3)
      contents << alphanumeric_field(record_contents.terms_frequency, 1)
      contents << numeric_field(record_contents.scheduled_monthly_payment_amount, 9)
      contents << numeric_field(record_contents.actual_payment_amount, 9)
      contents << alphanumeric_field(record_contents.account_status, 2)
      contents << alphanumeric_field(record_contents.payment_rating, 1)
      contents << alphanumeric_field(record_contents.payment_history_profile, 24)
      contents << alphanumeric_field(record_contents.special_comment, 2)
      contents << alphanumeric_field(record_contents.compliance_condition_code, 2)
      contents << numeric_field(record_contents.current_balance, 9)
      contents << numeric_field(record_contents.amount_past_due, 9)
      contents << numeric_field(record_contents.original_charge_off_amount, 9)
      contents << date_field(record_contents.account_information_date, 8)
      contents << date_field(record_contents.first_delinquency_date, 8)
      contents << date_field(record_contents.closed_date, 8)
      contents << date_field(record_contents.last_payment_date, 8)
      contents << alphanumeric_field(record_contents.interest_type_indicator, 1)
      contents << alphanumeric_field(nil, 16) # reserved - blank fill
      contents << alphanumeric_field(record_contents.consumer_transaction_type, 1)
      contents << alphanumeric_field(record_contents.surname, 25, ALPHANUMERIC_PLUS_DASH)
      contents << alphanumeric_field(record_contents.first_name, 20, ALPHANUMERIC_PLUS_DASH)
      contents << alphanumeric_field(record_contents.middle_name, 20, ALPHANUMERIC_PLUS_DASH)
      contents << alphanumeric_field(record_contents.generation_code, 1)
      contents << numeric_field(record_contents.social_security_number, 9)
      contents << date_field(record_contents.date_of_birth, 8)
      contents << numeric_field(record_contents.telephone_number, 10)
      contents << alphanumeric_field(record_contents.ecoa_code, 1)
      contents << alphanumeric_field(record_contents.consumer_information_indicator, 2)
      contents << alphanumeric_field(record_contents.country_code, 2)
      contents << alphanumeric_field(record_contents.address_1, 32, ALPHANUMERIC_PLUS_DOT_DASH_SLASH)
      contents << alphanumeric_field(record_contents.address_2, 32, ALPHANUMERIC_PLUS_DOT_DASH_SLASH)
      contents << alphanumeric_field(record_contents.city, 20)
      contents << alphanumeric_field(record_contents.state, 2)
      contents << alphanumeric_field(record_contents.postal_code, 9)
      contents << alphanumeric_field(record_contents.address_indicator, 1)
      contents << alphanumeric_field(record_contents.residence_code, 1)
      contents.join
    end

    def program_revision_date
      # Program revision date (01 if not modified)
      revision_date = @file_contents.header.program_revision_date
      if revision_date
        revision_date.strftime('%m%d%Y')
      else
        '01'
      end
    end

    def alphanumeric_field(field_contents, required_length, allow=ALPHANUMERIC)
      # Left justified and blank-filled
      field_contents = field_contents.to_s

      return ' ' * required_length  if field_contents.empty?

      unless has_correct_characters?(field_contents, allow)
        raise ArgumentError.new("Content (#{field_contents}) contains invalid characters")
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

    def date_field(field_contents, required_length)
      field_contents = field_contents.strftime('%m%d%Y') if field_contents
      numeric_field(field_contents, required_length, true)
    end

    def is_numeric?(str)
      !!(str =~ /\A\d+\.?\d*\z/)
    end

    def has_correct_characters?(str, allow)
      case allow
      when ALPHANUMERIC
        # must be alphanumeric with spaces
        !!(str =~ /\A([[:alnum:]]|\s)+\z/x)
      when ALPHANUMERIC_PLUS_DASH
        !!(str =~ /\A([[:alnum:]]|\s|\-)+\z/x)
      when ALPHANUMERIC_PLUS_DOT_DASH_SLASH
        !!(str =~ /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/x)
      end
    end
  end
end
