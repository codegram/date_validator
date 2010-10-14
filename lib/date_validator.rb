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
          record.errors.add(attr_name, I18n.t("errors.messages.not_a_date"), :value => value, :default => options[:message])
          return
        end
  
        options.slice(*CHECKS.keys).each do |option, option_value|
          option_value = option_value.call(record) if option_value.is_a?(Proc)
          option_value = record.send(option_value) if option_value.is_a?(Symbol)
       
          original_value = value
          original_option_value = option_value

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
            error_msg = options[:message] || I18n.t("errors.messages.#{option}", :value => original_option_value)
            record.errors.add(attr_name, error_msg, :default => options[:message], :value => original_value, :date => original_option_value)
          end
        end
      end

      def is_time?(object)
        object.is_a?(Time) || (defined?(Date) and object.is_a?(Date)) || (defined?(ActiveSupport::TimeWithZone) and object.is_a?(ActiveSupport::TimeWithZone))
      end

    end
  end
end
