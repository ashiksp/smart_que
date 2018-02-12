module Consumers
  class Base
    # Methods which are related to implement a base consumer.

    # The queue name should be defined here.
    QUEUE_NAME = 'smart_que.default'

    attr_accessor :queue_name

    def queue_name
      @queue_name
    end

    # This method will return the default queue which present
    # in the message queues. Consumer specific queue should be
    # defined and implemented in the consumer sub classes.
    def queue
      @queue ||= channel.queue(queue_name)
    end

    # Establish connection to Message Queues.
    def connection
      ::SmartQue.establish_connection
    end

    # Create channel with the established connection.
    def channel
      @channel ||= connection.create_channel
    end

    # Method which kick start the consumer process thread
    def start
      channel.prefetch(10)
      queue.subscribe(manual_ack: true, exclusive: false) do |delivery_info, metadata, payload|
        begin
          body = JSON.parse(payload).with_indifferent_access
          status = run(body)
        rescue => e
          status = :error
        end

        if status == :ok
          channel.ack(delivery_info.delivery_tag)
        elsif status == :retry
          channel.reject(delivery_info.delivery_tag, true)
        else # :error, nil etc
          channel.reject(delivery_info.delivery_tag, false)
        end
      end

      wait_for_threads
    end

    def wait_for_threads
      sleep
    end
  end
end
