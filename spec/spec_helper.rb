$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simplecov'
SimpleCov.start do
  add_group "Lib", "lib"
end

require 'rubygems'
require 'active_model'

require 'date_validator'
require 'rspec'

I18n.load_path += Dir[File.join('locales', '*.{rb,yml}')]

class TestRecord
  include ActiveModel::Validations
  attr_accessor :expiration_date

  def initialize(expiration_date)
    @expiration_date = expiration_date
  end
end
