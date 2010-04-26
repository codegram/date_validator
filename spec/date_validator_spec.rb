require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DateValidator" do

  before(:each) do
    TestRecord.reset_callbacks(:validate)
  end

  it "should check validity of the arguments" do
    [3, "foo", 1..6].each do |wrong_argument|
      begin
        TestRecord.validates :expiration_date, :date => {:before => wrong_argument}
        fail "should not accept a #{wrong_argument.class} as an option (only Time, Date, Symbol or Proc)"
      rescue=>e
        fail e unless e.is_a?(ArgumentError)
      end
    end
  end

  [:after, :before, :after_or_equal_to, :before_or_equal_to].each do |check|
    [:valid,:invalid].each do |should_be|

      model_date = case check
        when :after then should_be == :valid ? Time.now + 21000 : Time.now - 1
        when :before then should_be == :valid ? Time.now - 21000 : Time.now + 1
        when :after_or_equal_to then should_be == :valid ? Time.now + 21000 : Time.now - 21000
        when :before_or_equal_to then should_be == :valid ? Time.now - 21000 : Time.now + 21000
      end

      it "should ensure that an attribute is #{should_be} when #{should_be == :valid ? 'respecting' : 'offending' } the #{check} check" do
        TestRecord.validates :expiration_date, :date => {:"#{check}" => Time.now}
        model = TestRecord.new(model_date)
        should_be == :valid ? model.should(be_valid, "an attribute should be valid when respecting the #{check} check") : model.should(be_invalid, "an attribute should be invalid when offending the #{check} check")
      end

    end
  end

  extra_types = [:proc, :symbol]
  # extra_types.push(:date) if defined?(Date) and defined?(DateTime)

  extra_types.each do |type|
    it "should accept a #{type} as an argument to a check" do
      case type
        when :proc then
          TestRecord.validates :expiration_date, :date => {:after => Proc.new{Time.now + 21000}}
        when :symbol then
          begin
            TestRecord.send(:define_method, :min_date, lambda { Time.now + 21000 })
            TestRecord.validates :expiration_date, :date => {:after => :min_date}
          rescue=>e
            fail "is not accepting a #{type} as an argument to a check"
          end
        # when :date then
        #   TestRecord.validates :expiration_date, :date => {:after => Time.now.to_date}
      end 
    end
  end

end
