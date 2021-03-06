require 'connection_pool'

module SmartQue
  module Publishers
    class Base

      # List Queues from configuration
      def queue_list
        ::SmartQue.config.queues
      end

      def channel
        # Raise exception if connection is not_connected or closed
        if @channel && (!@channel.open? || !@channel.connection.open?)
          raise ConnectionError
        end

        # # Create new channel if closed
        if @channel.nil? # && connection.open?
          @channel = connection.create_channel
        end
        @channel
      end

      # Direct exchange
      def x_direct
        channel.direct("amq.direct")
      end

      def x_default
        channel.default_exchange
      end

      # Topic exchange
      def x_topic
        channel.topic("amq.topic")
      end

      # Fanout exchange
      def x_fanout
        channel.fanout("amq.fanout")
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
      def get_queue(q_name, options = {})
        unless options[:dot_format] == false
          q_name = modified_q_name(q_name)
        end
        channel.queue(q_name)
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