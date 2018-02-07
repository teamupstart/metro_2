module Metro2
  module Records
    class Record
      @fields = []

      class << self
        def fields
          @fields
        end
      end

      extend(Fields)

      def to_metro2
        validate_fields
        self.class.fields.collect { |f| send("#{f}_to_metro2") }.join
      end

      def validate_fields
        # this should be implemented by each child
      end
    end
  end
end
