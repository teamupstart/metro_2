module Metro2
  VERSION = "0.0.3"

  def self.version_string
    str = VERSION.split('.')
    str[0].ljust(2, '0') + str[1].ljust(2, '0') + str[2]
  end
end
