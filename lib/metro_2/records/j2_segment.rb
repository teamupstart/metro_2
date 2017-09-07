module Metro2::Records
  class J2Segment < Record
    @fields = []

    alphanumeric_const_field :segment_identifier, 2, 'J2'
    alphanumeric_const_field :reserved, 1, nil
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
    alphanumeric_const_field :reserved_2, 2, nil
  end
end
