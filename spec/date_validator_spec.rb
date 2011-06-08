require 'spec_helper'

module ActiveModel
  module Validations

    describe DateValidator do

      before do
        TestRecord.reset_callbacks(:validate)
      end

      it "checks validity of the arguments" do
        [3, "foo", 1..6].each do |wrong_argument|
          expect {
            TestRecord.validates :expiration_date, 
                                 :date => {:before => wrong_argument}
          }.to raise_error(ArgumentError, ":before must be a time, a date, a time_with_zone, a symbol or a proc")
        end
      end

      it "complains when no options are provided" do
        TestRecord.validates :expiration_date,
                             :date => {:before => Time.now}

        model = TestRecord.new(nil)
        model.should_not be_valid
        model.errors[:expiration_date].should eq(["is not a date"])
      end

      it "works with helper methods" do
        time = Time.now
        TestRecord.validates_date_of :expiration_date, :before => time
        model = TestRecord.new(time + 20000)
        model.should_not be_valid
      end

      [:valid,:invalid].each do |should_be|
        _context = should_be == :valid ? 'when value validates correctly' : 'when value does not match validation requirements'

        context _context do
          [:after, :before, :after_or_equal_to, :before_or_equal_to].each do |check|
              now = Time.now.to_datetime

              model_date = case check
                when :after then should_be == :valid ? now + 21000 : now - 1
                when :before then should_be == :valid ? now - 21000 : now + 1
                when :after_or_equal_to then should_be == :valid ? now : now - 21000
                when :before_or_equal_to then should_be == :valid ? now : now + 21000
              end

              it "ensures that an attribute is #{should_be} when #{should_be == :valid ? 'respecting' : 'offending' } the #{check} check" do
                TestRecord.validates :expiration_date,
                                     :date => {:"#{check}" => now}

                model = TestRecord.new(model_date)
                should_be == :valid ? model.should(be_valid, "an attribute should be valid when respecting the #{check} check")\
                                    : model.should_not(be_valid, "an attribute should be invalidwhen offending the #{check} check")
              end

              if _context == 'when value does not match validation requirements'
                it "yields a default error message indicating that value must be #{check} validation requirements" do
                  TestRecord.validates :expiration_date,
                                       :date => {:"#{check}" => now}

                  model = TestRecord.new(model_date)
                  model.should_not be_valid
                  model.errors[:expiration_date].should eq(["must be " + check.to_s.gsub('_',' ') + " #{I18n.localize(now)}"])
                end
              end
          end

          if _context == 'when value does not match validation requirements'
            now = Time.now.to_datetime

            it "allows for a custom validation message" do
              TestRecord.validates :expiration_date,
                                   :date => {:before_or_equal_to => now,
                                             :message => 'must be after Christmas'}

              model = TestRecord.new(now + 21000)
              model.should_not be_valid
              model.errors[:expiration_date].should eq(["must be after Christmas"])
            end

            it "allows custom validation message to be handled by I18n" do
              custom_message = 'Custom Date Message'
              I18n.backend.store_translations('en', {:errors => {:messages => {:not_a_date => custom_message}}})

              TestRecord.validates :expiration_date, :date => true

              model = TestRecord.new(nil)
              model.should_not be_valid
              model.errors[:expiration_date].should eq([custom_message])
            end
          end

        end
      end

      extra_types = [:proc, :symbol]
      extra_types.push(:date) if defined?(Date) and defined?(DateTime)
      extra_types.push(:time_with_zone) if defined?(ActiveSupport::TimeWithZone)

      extra_types.each do |type|
        it "accepts a #{type} as an argument to a check" do
          case type
            when :proc then
              expect {
                TestRecord.validates :expiration_date,
                                     :date => {:after => Proc.new{Time.now + 21000}}
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

      it "gracefully handles an unexpected result from a proc argument evaluation" do
        TestRecord.validates :expiration_date,
                             :date => {:after => Proc.new{ nil }}

        TestRecord.new(Time.now).should_not be_valid
      end

      it "gracefully handles an unexpected result from a symbol argument evaluation" do
        TestRecord.send(:define_method, :min_date, lambda { nil })
        TestRecord.validates :expiration_date,
                             :date => {:after => :min_date}

        TestRecord.new(Time.now).should_not be_valid
      end
    end

  end
end
