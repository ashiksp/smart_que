require_relative "publishers/base"

module SmartQue
  class Publisher < Publishers::Base
    
    # Initialize
    def initialize
      @channel = channel
      queue_list.each do |q_name|
        q = get_queue(q_name, @channel)
        q.bind(x_direct, routing_key: q.name)
      end
    end

    # Instance methods

    # Publish message to the respective queue
    def publish(queue, options = {})
      # Check queue name includes in the configured list
      # Return if queue doesn't exist
      if queue_list.include? queue
        # Publish sms to queue
        x_direct.publish(
                          options.to_json,
                          mandatory: true,
                          routing_key: get_queue(queue).name
                        )
        log_message("Publish status: success, Queue : #{queue}, Content : #{options}")
      else
        log_message("Publish status: failed, Queue(#{queue}) doesn't exist.")
        log_message("Content : #{options}")
        raise QueueNotFoundError
      end
    end
  end
end