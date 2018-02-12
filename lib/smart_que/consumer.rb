require_relative "consumers/base"

module SmartQue
  class Consumer < Consumers::Base
    
    # Initialize
    def initialize(queue_name = nil)
      @queue_name = ( queue_name || self.class::QUEUE_NAME )
    end

    # Instance methods

    # Consume message and perform tasks
    def run(payload)
      # Implement logic in the corresponding consumer
      Rails.logger.info "Not Implemented, Please define run method for the consumer class."
      :ok
    end
  end
end