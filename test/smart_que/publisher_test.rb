require 'test_helper'

module SmartQue
  describe Publisher do

    before do
      SmartQue.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.username = 'guest'
        f.password = 'guest'
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


    describe '#unicast' do

      let(:options) { { msisdn: "123456789", message: "Test Message" } }
      let(:publisher) { SmartQue::Publisher.new }

      it 'unicast the message to the queue' do

        queue = publisher.get_queue("test")
        queue.purge

        100.times do
          publisher.unicast('test', options)
        end

        # wait for all the messages to reach the queue
        sleep 1
        assert_equal 100, queue.message_count
        queue.purge
      end
    end

    describe '#multicast' do

      let(:options) { { msisdn: "123456789", message: "Test Message" } }
      let(:publisher) { SmartQue::Publisher.new }

      it 'multicast the message to the topic smart.queue' do

        queue_1 = publisher.get_queue("queue_1")
        queue_1.bind(publisher.x_topic, routing_key: 'smart.queue')
        queue_1.purge

        queue_2 = publisher.get_queue("queue_2")
        queue_2.bind(publisher.x_topic, routing_key: 'smart.*')
        queue_2.purge

        100.times do
          publisher.multicast('smart_queue', options)
        end

        # wait for all the messages to reach the queue
        sleep 1
        assert_equal 100, queue_1.message_count
        assert_equal 100, queue_2.message_count
        queue_1.purge
        queue_2.purge
      end
    end

    describe '#broadcast' do

      let(:options) { { msisdn: "123456789", message: "Test Message" } }
      let(:publisher) { SmartQue::Publisher.new }

      it 'broadcast the message to the topic smart.queue' do

        queue_1 = publisher.get_queue("queue_1")
        queue_1.bind(publisher.x_fanout)
        queue_1.purge

        queue_2 = publisher.get_queue("queue_2")
        queue_2.bind(publisher.x_fanout)
        queue_2.purge

        10.times do
          publisher.broadcast(options)
        end

        # wait for all the messages to reach the queue
        sleep 1
        assert_equal 10, queue_1.message_count
        assert_equal 10, queue_2.message_count
        queue_1.purge
        queue_2.purge
      end
    end
  end
end