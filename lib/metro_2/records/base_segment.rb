module Metro2::Records
  class BaseSegment < Record
    @fields = []

    numeric_field :record_descriptor_word, 4, Metro2::FIXED_LENGTH
    alphanumeric_const_field :processing_indicator, 1, 1 # always 1
    timestamp_field :time_stamp
    numeric_field :correction_indicator, 1
    alphanumeric_field :identification_number, 20
    alphanumeric_field :cycle_number, 2
    alphanumeric_field :consumer_account_number, 30
    alphanumeric_field :portfolio_type, 1
    alphanumeric_field :account_type, 2
    date_field :date_opened
    monetary_field :credit_limit
    monetary_field :highest_credit_or_loan_amount
    alphanumeric_field :terms_duration, 3
    alphanumeric_field :terms_frequency, 1
    monetary_field :scheduled_monthly_payment_amount
    monetary_field :actual_payment_amount
    alphanumeric_field :account_status, 2
    alphanumeric_field :payment_rating, 1
    alphanumeric_field :payment_history_profile, 24
    alphanumeric_field :special_comment, 2
    alphanumeric_field :compliance_condition_code, 2
    monetary_field :current_balance
    monetary_field :amount_past_due
    monetary_field :original_charge_off_amount
    date_field :account_information_date
    date_field :first_delinquency_date
    date_field :closed_date
    date_field :last_payment_date
    alphanumeric_field :interest_type_indicator, 1
    alphanumeric_const_field :reserved, 16, nil # reserved - blank fill
    alphanumeric_field :consumer_transaction_type, 1
    alphanumeric_field :surname, 25, Metro2::ALPHANUMERIC_PLUS_DASH
    alphanumeric_field :first_name, 20, Metro2::ALPHANUMERIC_PLUS_DASH
    alphanumeric_field :middle_name, 20, Metro2::ALPHANUMERIC_PLUS_DASH
    alphanumeric_field :generation_code, 1
    numeric_field :social_security_number, 9
    date_field :date_of_birth
    numeric_field :telephone_number, 10
    alphanumeric_field :ecoa_code, 1
    alphanumeric_field :consumer_information_indicator, 2
    alphanumeric_field :country_code, 2
    alphanumeric_field :address_1, 32, Metro2::ALPHANUMERIC_PLUS_DOT_DASH_SLASH
    alphanumeric_field :address_2, 32, Metro2::ALPHANUMERIC_PLUS_DOT_DASH_SLASH
    alphanumeric_field :city, 20, Metro2::ALPHANUMERIC_PLUS_DOT_DASH_SLASH
    alphanumeric_field :state, 2
    alphanumeric_field :postal_code, 9
    alphanumeric_field :address_indicator, 1
    alphanumeric_field :residence_code, 1

    def joint_segment=(joint_segment)
      @joint_segment = joint_segment
    end

    def joint_segment
      @joint_segment
    end

    def to_metro2
      if joint_segment
        joint_segment_to_metro2 = joint_segment.to_metro2
      end

      if joint_segment_to_metro2
        self.class.fields.collect { |f| send("#{f}_to_metro2") }.join + joint_segment_to_metro2
      else
        self.class.fields.collect { |f| send("#{f}_to_metro2") }.join
      end
    end
  end
end
