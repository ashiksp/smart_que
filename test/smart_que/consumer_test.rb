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

    let(:consumer) { SmartQue::Consumer.new('test_queue') }

    describe '#connection' do

      it 'creates connection' do
        assert consumer.connection
      end

      it 'creates a channel for consumer' do
        assert consumer.channel
      end

      it 'sets consumer queue as test_queue' do
        assert_equal consumer.queue_name, 'test_queue'
      end

      it 'has a queue' do
        assert consumer.queue
      end

      it 'loads proper configuration' do
        assert consumer.config.class, SmartQue::Config
      end
    end

    describe '#message consumption from queue' do

      it 'fetch messages from queue for consumption' do
        content = { msisdn: "123456789", message: "Test Message" }

        consumer.stub :wait_for_threads, nil do

          # Delete all messages from queue
          consumer.queue.purge

          100.times do
            consumer.queue.publish(content.to_json)
          end

          # wait for all the messages to reach the queue
          sleep 1
          assert_equal 100, consumer.queue.message_count

          consumer.start

          # Allow consumer to fetch all messages
          sleep 1
          assert_equal 0, consumer.queue.message_count
        end
      end
    end
  end
end