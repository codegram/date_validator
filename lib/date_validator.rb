require 'active_model/validations/date_validator'
require 'active_support/i18n'

module DateValidator
end

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]
