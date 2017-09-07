require 'date'

module Metro2
  class Metro2File
    include Fields

    attr_reader :base_segments
    attr_reader :header
    attr_reader :trailer

    def initialize
      @base_segments = []
      @header = Records::HeaderSegment.new
    end

    def to_s
      segments = []
      segments << @header
      @base_segments.each { |base| segments << base }
      @trailer ||= trailer_from_base_segments
      segments << @trailer

      segments.collect { |r| r.to_metro2 }.join("\n") + "\n"
    end

    def trailer_from_base_segments
      joint_segments = @base_segments.map(&:joint_segment).compact
      status_code_count = Hash.new(0)
      num_ssn = 0
      num_dob = 0
      num_telephone = 0
      num_ecoa_code_z = 0
      joint_ssn = 0
      joint_dob = 0

      @base_segments.each do |base|
        status_code_count[base.account_status.upcase] += 1
        num_ssn += 1 if  base.social_security_number
        num_dob += 1 if base.date_of_birth

        num_telephone += 1 if base.telephone_number
        num_telephone += 1 if base.joint_segment && base.joint_segment.telephone_number

        num_ecoa_code_z += 1 if base.ecoa_code == 'Z'
        num_ecoa_code_z += 1 if base.joint_segment && base.joint_segment.ecoa_code == 'Z'

        joint_ssn += 1 if base.joint_segment && base.joint_segment.social_security_number
        joint_dob += 1 if base.joint_segment && base.joint_segment.date_of_birth
      end

      trailer = Records::TrailerSegment.new
      trailer.total_base_records = @base_segments.size
      trailer.total_status_code_df = status_code_count['DF']
      trailer.total_status_code_da = status_code_count['DA']
      trailer.total_status_code_05 = status_code_count['05']
      trailer.total_status_code_11 = status_code_count['11']
      trailer.total_status_code_13 = status_code_count['13']
      trailer.total_status_code_61 = status_code_count['61']
      trailer.total_status_code_62 = status_code_count['62']
      trailer.total_status_code_63 = status_code_count['63']
      trailer.total_status_code_64 = status_code_count['64']
      trailer.total_status_code_65 = status_code_count['65']
      trailer.total_status_code_71 = status_code_count['71']
      trailer.total_status_code_78 = status_code_count['78']
      trailer.total_status_code_80 = status_code_count['80']
      trailer.total_status_code_82 = status_code_count['82']
      trailer.total_status_code_83 = status_code_count['83']
      trailer.total_status_code_84 = status_code_count['84']
      trailer.total_status_code_88 = status_code_count['88']
      trailer.total_status_code_89 = status_code_count['89']
      trailer.total_status_code_93 = status_code_count['93']
      trailer.total_status_code_94 = status_code_count['94']
      trailer.total_status_code_94 = status_code_count['95']
      trailer.total_status_code_96 = status_code_count['96']
      trailer.total_status_code_97 = status_code_count['97']
      trailer.ecoa_code_z = num_ecoa_code_z
      trailer.total_social_security_numbers = num_ssn + joint_ssn
      trailer.total_social_security_numbers_in_base = num_ssn
      trailer.total_date_of_births = num_dob + joint_dob
      trailer.total_date_of_births_in_base = num_dob
      trailer.total_telephome_numbers = num_telephone

      trailer.total_j1_segments = joint_segments.select { |js| js.segment_identifier == 'J1' }.size
      trailer.total_j2_segments = joint_segments.select { |js| js.segment_identifier == 'J2' }.size
      trailer.total_social_security_numbers_in_j1 = joint_segments.select { |js| js.segment_identifier == 'J1' && js.social_security_number }.size
      trailer.total_date_of_births_in_j1 = joint_segments.select { |js| js.segment_identifier == 'J1' && js.date_of_birth }.size
      trailer.total_social_security_numbers_in_j2 = joint_segments.select { |js| js.segment_identifier == 'J2' && js.social_security_number }.size
      trailer.total_date_of_births_in_j2 = joint_segments.select { |js| js.segment_identifier == 'J2' && js.date_of_birth }.size

      trailer
    end

  end
end
