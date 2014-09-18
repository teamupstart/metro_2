# Metro2

Creates files in Metro 2 format for reporting to credit agencies

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metro_2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metro_2

## Usage

```ruby
metro_2_content = Metro2::Metro2File.new
metro_2_content.header.cycle_number = 15
metro_2_content.header.equifax_program_identifier = 'EFAXID'
metro_2_content.header.transunion_program_identifier = 'TRANSUNION'
# ... other header segment attributes

base_segment = Metro2::Records::BaseSegment.new
base_segment.time_stamp = Time.new(2014, 9, 15, 17, 7, 45)
base_segment.identification_number = 'REPORTERXYZ'
base_segment.cycle_number = 1
base_segment.consumer_account_number = 'ABC123'
base_segment.portfolio_type = 'I'
# ... other base segment attributes
metro_2_content.base_segments << base_segment
# add more base segments as needed

metro_2_content.to_s # contents to write to file
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/metro_2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
