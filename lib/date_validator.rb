require 'active_model'

module ActiveModel
  module Validations
    class DateValidator < ActiveModel::EachValidator
      CHECKS = { :after => :>, :after_or_equal_to => :>=,
                :before => :<, :before_or_equal_to => :<=}.freeze

      def initialize(options)
        super(options.reverse_merge(:allow_nil => false))
      end

      def check_validity!
        keys = CHECKS.keys
        options.slice(*keys).each do |option, value|
          next if is_time?(value) || value.is_a?(Proc) || value.is_a?(Symbol) || (defined?(ActiveSupport::TimeWithZone) and value.is_a? ActiveSupport::TimeWithZone)
          raise ArgumentError, ":#{option} must be a time, a date, a time_with_zone, a symbol or a proc"
        end
      end

      def validate_each(record, attr_name, value)

        return if options[:allow_nil] && value.nil?

        unless value
          record.errors.add(attr_name, :not_a_date, options)
          return
        end
  
        options.slice(*CHECKS.keys).each do |option, option_value|
          
          if option_value.is_a?(Proc)
            option_value = option_value.call(record)
            
          elsif option_value.is_a?(Symbol)
            
            begin
              option_value = record.send(option_value)

            rescue NoMethodError => original_error
              begin
                original_option_value = option_value
                option_value = case option_value
                when :today
                  case option
                  when :after, :before_or_equal_to
                    Date.today.end_of_day
                  else
                    Date.today
                  end
                when :tomorrow
                  Date.tomorrow
                when :yesterday
                  Date.yesterday
                else
                  raise original_error
                end

              rescue NoMethodError
                raise original_error
              end
              
            end
            
          end
       
          original_value = value
          original_option_value ||= option_value

          # To enable to_i conversion, these types must be converted to Datetimes
          if defined?(ActiveSupport::TimeWithZone)
            option_value = option_value.to_datetime if option_value.is_a?(ActiveSupport::TimeWithZone) 
            value = value.to_datetime if value.is_a?(ActiveSupport::TimeWithZone)  
          end

          if defined?(Date)
            option_value = option_value.to_datetime if option_value.is_a?(Date) 
            value = value.to_datetime if value.is_a?(Date)  
          end
         
          unless is_time?(option_value) && value.to_i.send(CHECKS[option], option_value.to_i)
            record.errors.add(attr_name, option, options.merge(:value => original_value, :date => original_option_value))
          end
        end
      end

      def is_time?(object)
        object.is_a?(Time) || (defined?(Date) and object.is_a?(Date)) || (defined?(ActiveSupport::TimeWithZone) and object.is_a?(ActiveSupport::TimeWithZone))
      end

    end
  end
end

require 'active_support/i18n'
I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]
