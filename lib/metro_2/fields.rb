module Metro2
  module Fields

    ALPHANUMERIC = /\A([[:alnum:]]|\s)+\z/
    ALPHANUMERIC_PLUS_DASH = /\A([[:alnum:]]|\s|\-)+\z/
    ALPHANUMERIC_PLUS_DOT_DASH_SLASH = /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/
    NUMERIC = /\A\d+\.?\d*\z/

    FIXED_LENGTH = 426

    def alphanumeric_field(name, required_length, permitted_chars = ALPHANUMERIC)
      fields << name

      # getter
      define_method name do
        instance_variable_get( "@#{name}" )
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set( "@#{name}", val )
      end

      # to_metro2
      define_method  "#{name}_to_metro2" do
        # Left justified and blank-filled
        val = instance_variable_get( "@#{name}" )
        val = val.to_s

        return ' ' * required_length  if val.empty?

        unless !!(val =~ permitted_chars)
          raise ArgumentError.new("Content (#{val}) contains invalid characters")
        end

        if val.size > required_length
          val[0..(required_length-1)]
        else
          val + (' ' * (required_length - val.size))
        end
      end
    end

    def numeric_field(name, required_length, is_monetary = false)
      fields << name

      # getter
      define_method name do
        instance_variable_get( "@#{name}" )
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set( "@#{name}", val )
      end

      # to_metro2
      define_method  "#{name}_to_metro2" do
        # Right justified and zero-filled
        val = instance_variable_get( "@#{name}" )
        val = val.to_s

        return '0' * required_length if val.empty?

        unless !!(val =~ NUMERIC)
          raise ArgumentError.new("field (#{val}) must be numeric")
        end

        decimal_index = val.index('.')
        val = val[0..decimal_index-1] if decimal_index

        return '9' * required_length if is_monetary && val.to_f >= 1000000000
        if val.size > required_length
          raise ArgumentError.new("numeric field (#{val}) is too long (max #{required_length})")
        end

        ('0' * (required_length - val.size)) + val
      end
    end

    def alphanumeric_const_field(name, required_length, val, permitted_chars = ALPHANUMERIC)
      fields << name

      # getter
      define_method name do
        val
      end

      # to_metro2

      define_method "#{name}_to_metro2" do
        # Left justified and blank-filled
        val = val.to_s

        return ' ' * required_length  if val.empty?

        unless !!(val =~ permitted_chars)
          raise ArgumentError.new("Content (#{val}) contains invalid characters")
        end

        if val.size > required_length
          val[0..(required_length-1)]
        else
          val + (' ' * (required_length - val.size))
        end
      end
    end

    def numeric_const_field(name, required_length, val, is_monetary = false)
      fields << name

      # getter
      define_method name do
        val
      end

      # to_metro2
      define_method "#{name}_to_metro2" do
        # Right justified and zero-filled
        val = val.to_s

        return '0' * required_length if val.empty?

        unless !!(val =~ NUMERIC)
          raise ArgumentError.new("field (#{val}) must be numeric")
        end

        decimal_index = val.index('.')
        val = val[0..decimal_index-1] if decimal_index

        return '9' * required_length if is_monetary && val.to_f >= 1000000000
        if val.size > required_length
          raise ArgumentError.new("numeric field (#{val}) is too long (max #{required_length})")
        end

        ('0' * (required_length - val.size)) + val
      end
    end

    def monetary_field(name)
      numeric_field(name, 9, true)
    end

    def date_field(name)
      numeric_field(name, 8)
    end
  end

end
