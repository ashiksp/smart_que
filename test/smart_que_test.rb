require "test_helper"

class SmartQueTest < Minitest::Test

  before do
    SmartQue.configure do |f|
      f.host = 'localhost'
      f.port = '5672'
      f.username = 'guest'
      f.password = "guest"
      f.queues = ['push_default', 'sms_otp']
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::SmartQue::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
