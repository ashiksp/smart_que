module SmartQue
  module Publishers
    class Base
      # List Queues from configuration
      def queue_list
        @queue_list ||= ::SmartQue.config.queues
      end

      # Methods related to bunny exchange, channels, queues
      def channel
        @channel ||= connection.create_channel
      end

      # Direct exchange
      def x_direct
        @x_direct ||= channel.direct("amq.direct")
      end

      # Topic exchange
      def x_topic
        @x_topic ||= channel.topic("amq.topic")
      end

      # Connection Object
      def connection
        ::SmartQue.establish_connection
      end

      def find_or_initialize_queue(q_name)
        q = get_queue(q_name)
        q.bind(x_direct, routing_key: q.name)
      end

      # Get/Set queue with name
      # name : sms_otp
      def get_queue(q_name)
        channel.queue(modified_q_name(q_name))
      end

      # Logging
      def log_message(data)
        ::SmartQue.log(data)
      end

      def config
        ::SmartQue.config
      end

      private

      def modified_q_name(q_name)
        dot_formatted(q_name)
      end

      def dot_formatted(name_string)
        name_string.downcase.gsub(/[\/|\_]/,".")
      end
    end
  end
end