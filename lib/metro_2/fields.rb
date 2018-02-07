module Metro2
  module Fields
    def alphanumeric_field(name, required_length, permitted_chars = Metro2::ALPHANUMERIC)
      fields << name

      # getter
      define_method name do
        instance_variable_get("@#{name}")
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set("@#{name}", val)
      end

      # to_metro2
      define_method "#{name}_to_metro2" do
        val = instance_variable_get("@#{name}")
        Metro2.alphanumeric_to_metro2(val, required_length, permitted_chars, name)
      end
    end

    def numeric_field(name, required_length, is_monetary: false, possible_values: nil)
      fields << name

      # getter
      define_method name do
        instance_variable_get("@#{name}")
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set("@#{name}", val)
      end

      # to_metro2
      define_method "#{name}_to_metro2" do
        val = instance_variable_get("@#{name}")
        Metro2.numeric_to_metro2(val, required_length, is_monetary: is_monetary,
                                 name: name, possible_values: possible_values)
      end
    end

    def alphanumeric_const_field(name, required_length, val, permitted_chars = Metro2::ALPHANUMERIC)
      fields << name

      # getter
      define_method name do
        val
      end

      # to_metro2

      define_method "#{name}_to_metro2" do
        Metro2.alphanumeric_to_metro2(val, required_length, permitted_chars, name)
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
        Metro2.numeric_to_metro2(val, required_length, is_monetary: is_monetary)
      end
    end

    def monetary_field(name)
      numeric_field(name, 9, is_monetary: true)
    end

    def date_field(name)
      fields << name

      # getter
      define_method name do
        instance_variable_get("@#{name}")
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set("@#{name}", val)
      end

      # to_metro2
      define_method "#{name}_to_metro2" do
        # Right justified and zero-filled
        val = instance_variable_get("@#{name}")
        val = val&.strftime('%m%d%Y')

        Metro2.numeric_to_metro2(val, 8)
      end
    end

    def timestamp_field(name)
      fields << name

      # getter
      define_method name do
        instance_variable_get("@#{name}")
      end

      # setter (includes validations)
      define_method "#{name}=" do | val |
        instance_variable_set("@#{name}", val)
      end

      # to_metro2
      define_method "#{name}_to_metro2" do
        # Right justified and zero-filled
        val = instance_variable_get("@#{name}")
        val = val&.strftime('%m%d%Y%H%M%S')
        Metro2.numeric_to_metro2(val, 14)
      end
    end
  end

end
