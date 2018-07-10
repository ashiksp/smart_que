require_relative "publishers/base"

module SmartQue
  class Publisher < Publishers::Base
    
    # Initialize
    def initialize
      queue_list.each do |q_name|
        find_or_initialize_queue(q_name)
      end
    end

    # Instance methods

    # Publish message to the respective queue
    def publish(queue, payload = {})
      # Check queue name includes in the configured list
      # Return if queue doesn't exist
      if queue_list.include? queue
        # Publish sms to queue
        x_direct.publish(
          payload.to_json,
          mandatory: true,
          routing_key: get_queue(queue).name
        )
        log_message("Publish status: success, Queue : #{queue}, Content : #{payload}")
      else
        log_message("Publish status: failed, Queue(#{queue}) doesn't exist.")
        log_message("Content : #{payload}")
        raise QueueNotFoundError
      end
    end

    # unicast message to queues
    def unicast(q_name, payload = {})
      x_default.publish(
        payload.to_json,
        routing_key: dot_formatted(q_name)
      )
      log_message("unicast status: success, Queue : #{q_name}, Content : #{payload}")
    end


    # multicast message to queues based on topic subscription
    def multicast(topic, payload = {})
      x_topic.publish(
        payload.to_json,
        routing_key: dot_formatted(topic)
      )
      log_message("multicast status: success, Topic : #{topic}, Content : #{payload}")
    end

    # broadcast message to queues based on topic subscription
    def broadcast(payload = {})
      x_fanout.publish(
        payload.to_json
      )
      log_message("broadcast status: success, Content : #{payload}")
    end
  end
end