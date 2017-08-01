require 'test_helper'

module SmartQue
  describe Publisher do

    before do
      SmartQue.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.username = 'guest'
        f.password = "guest"
        f.queues = ['push_default', 'sms_otp']
      end
    end

    describe 'publish interface function' do
      it 'implement a publish interface function' do
        assert SmartQue::Publisher.new.respond_to?(:publish)
      end
    end

    describe '#connection' do

      let(:publisher) { SmartQue::Publisher.new }

      it 'creates connection' do
        assert publisher.connection
      end

      it 'creates a channel for publisher' do
        assert publisher.channel
      end

      it 'creates a direct exchange for publishing content' do
        assert publisher.x_direct
      end

      it 'lists all the configured queues' do
        assert_equal publisher.queue_list, ["push_default", "sms_otp"]
      end

      it 'creates a smart_que publisher queue named as: push.default' do
        q = publisher.get_queue('push_default')
        assert_equal q.name, 'push.default'
      end

      it 'creates a smart_que publisher queue named as: sms.otp' do
        q = publisher.get_queue('sms_otp')
        assert_equal q.name, 'sms.otp'
      end
    end

    describe '#publish' do

      let(:options) { { msisdn: "123456789", message: "Test Message" } }
      let(:publisher) { SmartQue::Publisher.new }

      it 'publish the message to the default queue and return success response' do

        queue = publisher.get_queue("push_default")
        queue.purge

        response = publisher.publish('push_default', options)

        # wait for the messages to reach the queue
        sleep 1
        assert_equal 1, queue.message_count

        queue.purge
      end

      it 'publish the message to the default queue and return failure response' do

        assert_raises QueueNotFoundError do
          publisher.publish('null_queue', options)
        end

        err = -> { publisher.publish('null_queue', options) }.must_raise QueueNotFoundError
        assert_equal err.message, "Queue doesn't exist"
      end

      it 'publish the message to the queue' do

        queue = publisher.get_queue("push_default")
        queue.purge

        100.times do
          publisher.publish('push_default', options)
        end

        # wait for all the messages to reach the queue
        sleep 1
        assert_equal 100, queue.message_count
        queue.purge
      end
    end
  end
end