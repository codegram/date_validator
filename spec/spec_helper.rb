$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'active_model'

require 'lib/date_validator'
require 'spec'
require 'spec/autorun'


class TestRecord
  include ActiveModel::Validations
  attr_accessor :expiration_date

  def initialize(expiration_date)
    @expiration_date = expiration_date
  end
end

Spec::Runner.configure do |config|
  
end
