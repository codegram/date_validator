require 'active_model/validations/date_validator'
require 'active_support/i18n'

# A simple date validator for Rails 3.
#
# @example
#    validates :expiration_date,
#              :date => {:after => Proc.new { Time.now },
#                        :before => Proc.new { Time.now + 1.year } }
#    # Using Proc.new prevents production cache issues
#
module DateValidator
end

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]
