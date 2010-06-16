require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'active_support/time' # For testing Date and TimeWithZone objects

describe "DateValidator" do

  before(:each) do
    TestRecord.reset_callbacks(:validate)
  end

  it "should check validity of the arguments" do
    [3, "foo", 1..6].each do |wrong_argument|
      expect {
        TestRecord.validates :expiration_date, :date => {:before => wrong_argument}
      }.to raise_error(ArgumentError, ":before must be a time, a date, a time_with_zone, a symbol or a proc")
    end
  end

  [:after, :before, :after_or_equal_to, :before_or_equal_to].each do |check|
    [:valid,:invalid].each do |should_be|

      now = Time.now.to_datetime

      model_date = case check
        when :after then should_be == :valid ? now + 21000 : now - 1
        when :before then should_be == :valid ? now - 21000 : now + 1
        when :after_or_equal_to then should_be == :valid ? now : now - 21000
        when :before_or_equal_to then should_be == :valid ? now : now + 21000
      end

      it "should ensure that an attribute is #{should_be} when #{should_be == :valid ? 'respecting' : 'offending' } the #{check} check" do
        TestRecord.validates :expiration_date, :date => {:"#{check}" => Time.now}
        model = TestRecord.new(model_date)
        should_be == :valid ? model.should(be_valid, "an attribute should be valid when respecting the #{check} check") : model.should(be_invalid, "an attribute should be invalid when offending the #{check} check")
      end

    end
  end

  extra_types = [:proc, :symbol]
  extra_types.push(:date) if defined?(Date) and defined?(DateTime)
  extra_types.push(:time_with_zone) if defined?(ActiveSupport::TimeWithZone)

  extra_types.each do |type|
    it "should accept a #{type} as an argument to a check" do
      case type
        when :proc then
          expect {
            TestRecord.validates :expiration_date, :date => {:after => Proc.new{Time.now + 21000}}
          }.to_not raise_error
        when :symbol then
          expect {
            TestRecord.send(:define_method, :min_date, lambda { Time.now + 21000 })
            TestRecord.validates :expiration_date, :date => {:after => :min_date}
          }.to_not raise_error
        when :date then
          expect {
            TestRecord.validates :expiration_date, :date => {:after => Time.now.to_date}
          }.to_not raise_error
        when :time_with_zone then
          expect {
            Time.zone = "Hawaii"
            TestRecord.validates :expiration_date, :date => {:before => Time.zone.parse((Time.now + 21000).to_s)}
          }.to_not raise_error
      end
    end
  end

  it "should gracefully handle an unexpected result from a proc argument evaluation" do
    TestRecord.validates :expiration_date, :date => {:after => Proc.new{ nil }}
    TestRecord.new(Time.now).should_not be_valid
  end

  it "should gracefully handle an unexpected result from a symbol argument evaluation" do
    TestRecord.send(:define_method, :min_date, lambda { nil })
    TestRecord.validates :expiration_date, :date => {:after => :min_date}
    TestRecord.new(Time.now).should_not be_valid
  end
end
