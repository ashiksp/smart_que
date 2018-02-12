require 'test_helper'

module SmartQue
  describe Consumer do

    before do
      SmartQue.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.username = 'guest'
        f.password = "guest"
        f.queues = ['push_default', 'sms_otp']
      end
    end

    describe '#connection' do

      let(:consumer) { SmartQue::Consumer.new('test_queue') }

      it 'creates connection' do
        assert consumer.connection
      end

      it 'creates a channel for consumer' do
        assert consumer.channel
      end

      it 'sets consumer queue as test_queue' do
        assert_equal consumer.queue_name, 'test_queue'
      end
    end
  end
end