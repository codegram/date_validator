require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DateValidator" do
  before(:each) do
    @model = TestRecord.new(Time.now + 2347887234)
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

  # TODO MEGA DRY SHIT
  [1,2,3,4].each do |option|
    it "should ensure that #{option} the attribute is :before => a specific date" do
      TestRecord.validates :expiration_date, :date => {:before => Time.now}
      invalid_model = TestRecord.new(Time.now + 21000)
      invalid_model.should_not be_valid
    end
  end

end
