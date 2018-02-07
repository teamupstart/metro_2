require 'metro_2/version'

module Metro2

  PORTFOLIO_TYPE = {
    line_of_credit: 'C',
    installment: 'I',
    mortgage: 'M',
    open_account: 'O',
    revolving: 'R'
  }.freeze

  ACCOUNT_TYPE = {
    unsecured: '01',
    education: '12'
    # TODO: add other account types
  }.freeze

  ECOA_CODE = {
    individual: '1',
    deceased: 'X'
    # TODO: add other ECOA codes
  }.freeze

  SPECIAL_COMMENT_CODE = {
    partial_payment_agreement: 'AC',
    purchased_by_another_company: 'AH',
    paid_in_full_less_than_full_balance: 'AU',
    affected_by_natural_or_declared_disaster: 'AW',
    loan_modified: 'CO',
    forbearance: 'CP',
    # TODO: add other special comment codes
  }.freeze

  COMPLIANCE_CONDITION_CODE = {
    in_dispute: 'XF'
    # TODO: add other compliance condition codes
  }.freeze

  INTEREST_TYPE_INDICATOR = {
    fixed: 'F',
    variable: 'V'
  }.freeze

  CORRECTION_INDICATOR = '1'

  TERMS_FREQUENCY = {
    deferred: 'D',
    single_payment: 'P',
    weekly: 'W',
    biweekly: 'B',
    semimonthly: 'S',
    monthly: 'M',
    bimonthly: 'L',
    quarterly: 'Q',
    triannually: 'T',
    semiannually: 'S',
    annually: 'Y'
  }.freeze

  ACCOUNT_STATUS = {
    account_transferred: '05',
    current: '11',
    closed: '13',
    paid_in_full_voluntary_surrender: '61',
    paid_in_full_collection_account: '62',
    paid_in_full_repossession: '63',
    paid_in_full_charge_off: '64',
    paid_in_full_foreclosure: '65',
    past_due_30_59: '71',
    past_due_60_89: '78',
    past_due_90_119: '80',
    past_due_120_149: '82',
    past_due_150_179: '83',
    past_due_180_plus: '84',
    govt_insurance_claim_filed: '88',
    deed_received: '89',
    collections: '93',
    foreclosure_completed: '94',
    voluntary_surrender: '95',
    merch_repossessed: '96',
    charge_off: '97',
    delete_account: 'DA',
    delete_account_fraud: 'DF'
  }.freeze

  PAYMENT_HISTORY_PROFILE = {
    current: '0',
    past_due_30_59: '1',
    past_due_60_89: '2',
    past_due_90_119: '3',
    past_due_120_149: '4',
    past_due_150_179: '5',
    past_due_180_plus: '6',
    no_history_prior: 'B',
    no_history_available: 'D',
    zero_balance: 'E',
    collection: 'G',
    foreclosure_completed: 'H',
    voluntary_surrender: 'J',
    repossession: 'K',
    charge_off: 'L'
  }.freeze

  CONSUMER_TRANSACTION_TYPE = {
    new_account_or_new_borrower: '1',
    name_change: '2',
    address_change: '3',
    ssn_change: '5',
    name_and_address_change: '6',
    name_and_ssn_change: '8',
    address_and_ssn_change: '9',
    name_address_and_ssn_change: 'A'
  }.freeze

  ADDRESS_INDICATOR = {
    confirmed: 'C',
    known: 'Y',
    not_confirmed: 'N',
    military: 'M',
    secondary: 'S',
    business: 'B',
    non_deliverable: 'U',
    data_reporters_default: 'D',
    bill_payer_service: 'P'
  }.freeze

  RESIDENCE_CODE = {
    owns: 'O',
    rents: 'R'
  }.freeze

  GENERATION_CODE = {
    junior: 'J',
    senior: 'S',
    ii: '2',
    iii: '3',
    iv: '4',
    v: '5',
    vi: '6',
    vii: '7',
    viii: '8',
    ix: '9'
  }.freeze

  CONSUMER_INFORMATION_INDICATOR = {
    petition_ch7: 'A',
    petition_ch11: 'B',
    petition_ch12: 'C',
    petition_ch13: 'D',
    discharged_ch7: 'E',
    discharged_ch11: 'F',
    discharged_ch12: 'G',
    discharged_ch13: 'H',
    dismissed_ch7: 'I',
    dismissed_ch11: 'J',
    dismissed_ch12: 'K',
    dismissed_ch13: 'L',
    withdrawn_ch7: 'M',
    withdrawn_ch11: 'N',
    withdrawn_ch12: 'O',
    withdrawn_ch13: 'P',
  }

  ALPHANUMERIC = /\A([[:alnum:]]|\s)+\z/
  ALPHANUMERIC_PLUS_DASH = /\A([[:alnum:]]|\s|\-)+\z/
  ALPHANUMERIC_PLUS_DOT_DASH_SLASH = /\A([[:alnum:]]|\s|\-|\.|\\|\/)+\z/
  NUMERIC = /\A\d+\.?\d*\z/

  FIXED_LENGTH = 426

  def self.account_status_needs_payment_rating?(account_status)
    account_status.in?([ACCOUNT_STATUS[:account_transferred], ACCOUNT_STATUS[:closed],
                        ACCOUNT_STATUS[:paid_in_full_foreclosure], ACCOUNT_STATUS[:govt_insurance_claim_filed],
                        ACCOUNT_STATUS[:deed_received], ACCOUNT_STATUS[:foreclosure_completed],
                        ACCOUNT_STATUS[:voluntary_surrender]])
  end

  def self.alphanumeric_to_metro2(val, required_length, permitted_chars, name)
    # Left justified and blank-filled
    val = val.to_s

    return ' ' * required_length  if val.empty?

    unless !!(val =~ permitted_chars)
      raise ArgumentError.new("Content (#{val}) contains invalid characters in field '#{name}'")
    end

    if val.size > required_length
      val[0..(required_length-1)]
    else
      val + (' ' * (required_length - val.size))
    end
  end

  def self.numeric_to_metro2(val, required_length,
                             is_monetary: false, name: nil, possible_values: nil)
    unless possible_values.nil? || possible_values.include?(val)
      raise ArgumentError.new("field #{name} has unsupported value: #{val}")
    end

    # Right justified and zero-filled
    val = val.to_s

    return '0' * required_length if val.empty?

    unless !!(val =~ Metro2::NUMERIC)
      raise ArgumentError.new("field (#{val}) must be numeric")
    end

    decimal_index = val.index('.')
    val = val[0..(decimal_index - 1)] if decimal_index

    # any value above 1 billion gets set to 999,999,999
    return '9' * required_length if is_monetary && val.to_f >= 1000000000
    if val.size > required_length
      raise ArgumentError.new("numeric field (#{val}) is too long (max #{required_length})")
    end

    ('0' * (required_length - val.size)) + val
  end
end

require 'metro_2/fields'
require 'metro_2/metro2_file'

# Require records files
require 'metro_2/records/record'

Dir.new(File.dirname(__FILE__) + '/metro_2/records').each do |file|
  require('metro_2/records/' + File.basename(file)) if File.extname(file) == ".rb"
end
