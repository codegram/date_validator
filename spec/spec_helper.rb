require 'simplecov'
SimpleCov.start do
  add_group "Lib", "lib"
end

require 'rspec'

require 'active_support/time' # For testing Date and TimeWithZone objects

require 'active_model'
require 'date_validator'

class TestRecord
  include ActiveModel::Validations
  attr_accessor :expiration_date

  def initialize(expiration_date)
    @expiration_date = expiration_date
  end
end
