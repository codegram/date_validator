require 'active_model/validations'

# ActiveModel Rails module.
module ActiveModel

  # ActiveModel::Validations Rails module. Contains all the default validators.
  module Validations

    # Date Validator. Inherits from ActiveModel::EachValidator.
    #
    # Responds to the regular validator API methods `#check_validity` and
    # `#validate_each`.
    class DateValidator < ActiveModel::EachValidator

      # Implemented checks and their associated operators.
      CHECKS = { :after => :>, :after_or_equal_to => :>=,
                :before => :<, :before_or_equal_to => :<=}.freeze

      # Call `#initialize` on the superclass, adding a default
      # `:allow_nil => false` option.
      def initialize(options)
        super(options.reverse_merge(:allow_nil => false))
      end

      # Validates the arguments passed to the validator.
      #
      # They must be either any kind of Time, a Proc, or a Symbol.
      def check_validity!
        keys = CHECKS.keys
        options.slice(*keys).each do |option, value|
          next if is_time?(value) || value.is_a?(Proc) || value.is_a?(Symbol) || (defined?(ActiveSupport::TimeWithZone) and value.is_a? ActiveSupport::TimeWithZone)
          raise ArgumentError, ":#{option} must be a time, a date, a time_with_zone, a symbol or a proc"
        end
      end

      # The actual validator method. It is called when ActiveRecord iterates
      # over all the validators.
      def validate_each(record, attr_name, value)
        return if options[:allow_nil] && value.nil?

        unless value
          record.errors.add(attr_name, :not_a_date, options)
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
            record.errors.add(attr_name, option, options.merge(
                :value => original_value,
                :date  => (I18n.localize(original_option_value) rescue original_option_value)
            ))
          end
        end
      end

      private

      def is_time?(object)
        object.is_a?(Time) || (defined?(Date) and object.is_a?(Date)) || (defined?(ActiveSupport::TimeWithZone) and object.is_a?(ActiveSupport::TimeWithZone))
      end
    end

    module HelperMethods
      # Validates whether the value of the specified attribute is a validate Date
      #
      #   class Person < ActiveRecord::Base
      #     validates_date_of :payment_date, :after => :packaging_date
      #     validates_date_of :expiration_date, :before => Proc.new { Time.now }
      #   end
      #
      # Configuration options:
      # * <tt>:after</tt> - check that a Date is after the specified one.
      # * <tt>:before</tt> - check that a Date is before the specified one.
      # * <tt>:after_or_equal_to</tt> - check that a Date is after or equal to the specified one.
      # * <tt>:before_or_equal_to</tt> - check that a Date is before or equal to the specified one.
      def validates_date_of(*attr_names)
        validates_with DateValidator, _merge_attributes(attr_names)
      end
    end
  end
end
