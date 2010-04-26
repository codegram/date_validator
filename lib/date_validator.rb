class DateValidator < ActiveModel::EachValidator
  CHECKS = { :after => :>, :after_or_equal_to => :>=,
            :before => :<, :before_or_equal_to => :<=}.freeze

  def initialize(options)
    super(options.reverse_merge(:allow_nil => false))
  end

  def check_validity!
    keys = CHECKS.keys
    options.slice(*keys).each do |option, value|
      next if value.is_a?(Time) || value.is_a?(Proc) || value.is_a?(Symbol)
      raise ArgumentError, ":#{option} must be a date, a symbol or a proc"
    end
  end

  def validate_each(record, attr_name, value)

    return if options[:allow_nil] && value.nil?

    unless value
      record.errors.add(attr_name, :not_a_date, :value => value, :default => options[:message])
      return
    end

    options.slice(*CHECKS.keys).each do |option, option_value|
      option_value = option_value.call(record) if option_value.is_a?(Proc)
      option_value = record.send(option_value) if option_value.is_a?(Symbol)

      unless value.send(CHECKS[option], option_value)
        record.errors.add(attr_name, option, :default => options[:message], :value => value, :date => option_value)
      end
    end      
  end
end
