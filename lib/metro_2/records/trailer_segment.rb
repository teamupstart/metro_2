module Metro2::Records
  class TrailerSegment < Record
    @fields = []

    numeric_const_field :record_descriptor_word, 4, Metro2::FIXED_LENGTH
    alphanumeric_const_field :record_identifier, 7, 'TRAILER'
    numeric_field :total_base_records, 9
    alphanumeric_const_field :reserved, 9, nil
    numeric_field :total_status_code_df, 9
    numeric_field :total_j1_segments, 9
    numeric_field :total_j2_segments, 9
    numeric_field :block_count, 9
    numeric_field :total_status_code_da, 9
    numeric_field :total_status_code_05, 9
    numeric_field :total_status_code_11, 9
    numeric_field :total_status_code_13, 9
    numeric_field :total_status_code_61, 9
    numeric_field :total_status_code_62, 9
    numeric_field :total_status_code_63, 9
    numeric_field :total_status_code_64, 9
    numeric_field :total_status_code_65, 9
    numeric_field :total_status_code_71, 9
    numeric_field :total_status_code_78, 9
    numeric_field :total_status_code_80, 9
    numeric_field :total_status_code_82, 9
    numeric_field :total_status_code_83, 9
    numeric_field :total_status_code_84, 9
    numeric_field :total_status_code_88, 9
    numeric_field :total_status_code_89, 9
    numeric_field :total_status_code_93, 9
    numeric_field :total_status_code_94, 9
    numeric_field :total_status_code_95, 9
    numeric_field :total_status_code_96, 9
    numeric_field :total_status_code_97, 9
    numeric_field :ecoa_code_z, 9
    numeric_field :total_n1_segments, 9
    numeric_field :total_k1_segments, 9
    numeric_field :total_k2_segments, 9
    numeric_field :total_k3_segments, 9
    numeric_field :total_k4_segments, 9
    numeric_field :total_l1_segments, 9
    numeric_field :total_social_security_numbers, 9
    numeric_field :total_social_security_numbers_in_base, 9
    numeric_field :total_social_security_numbers_in_j1, 9
    numeric_field :total_social_security_numbers_in_j2, 9
    numeric_field :total_date_of_births, 9
    numeric_field :total_date_of_births_in_base, 9
    numeric_field :total_date_of_births_in_j1, 9
    numeric_field :total_date_of_births_in_j2, 9
    numeric_field :total_telephome_numbers, 9
    alphanumeric_const_field :reserved_2, 19, nil
  end
end
