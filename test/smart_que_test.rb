require "test_helper"

class SmartQueTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::SmartQue::VERSION
  end

  def test_it_has_a_proper_configuration
    assert_equal SmartQue.config.class, SmartQue::Config
  end

  describe SmartQue do

    before do
      SmartQue.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.vhost = 'test'
        f.username = 'guest'
        f.password = "guest"
        f.queues = ['push_default', 'sms_otp']
      end
    end

    describe SmartQue::Config do

      it 'loads the default configuration' do
        assert_equal SmartQue.config.host, 'localhost'
      end

      it 'loads the vhost configuration' do
        assert_equal SmartQue.config.vhost, 'test'
      end

      it 'allow to add custom configuration' do
        assert_equal SmartQue.config.port, "5672"

        SmartQue.configure do |f|
          f.port = '1234'
        end

        assert_equal SmartQue.config.port, "1234"
      end

      it 'raise error for unsupported configuration' do
        assert_raises do
          SmartQue.configure do |f|
            f.test_port = '1235'
          end
        end
      end
    end

    describe '.establish_connection' do
      it 'establish_connection to a rabbitmq server' do
        assert SmartQue.establish_connection
      end
    end
  end
end
