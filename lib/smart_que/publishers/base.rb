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

      # Connection Object
      def connection
        ::SmartQue.establish_connection
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
        q_name.downcase.sub('_','.')
      end
    end
  end
end