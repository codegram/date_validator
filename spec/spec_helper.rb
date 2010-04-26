$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'date_validator'
require 'spec'
require 'spec/autorun'

require 'active_model'
require 'date_validator'

class TestRecord
  include ActiveModel::Validations
  attr_accessor :expiration_date
  def initialize(expiration_date)
    @expiration_date = expiration_date
  end
end

Spec::Runner.configure do |config|
  
end
