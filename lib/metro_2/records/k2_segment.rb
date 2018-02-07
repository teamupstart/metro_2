module Metro2::Records
  class K2Segment < Record
    LENGTH = 34

    @fields = []

    alphanumeric_const_field :segment_identifier, 2, "K2"
    numeric_field :purchased_from_sold_to_indicator, 1,
                  possible_values: Metro2::PURCHASED_FROM_SOLD_TO_INDICATOR.values
    alphanumeric_field :purchased_from_sold_to_name, 30, Metro2::ALPHANUMERIC_PLUS_DOT_DASH_SLASH
    alphanumeric_const_field :reserved, 1, nil # reserved - blank fill

    def validate_fields
      if !purchased_from_sold_to_name.nil? &&
          purchased_from_sold_to_indicator == Metro2::PURCHASED_FROM_SOLD_TO_INDICATOR[:remove_previous]
        str = "purchased_from_sold_to_name must be blank if purchased_from_sold_to_indicator is 9"
        raise ArgumentError.new(str)
      end
    end
  end
end
