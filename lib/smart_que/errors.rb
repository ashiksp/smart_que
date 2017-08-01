module SmartQue
  class QueueNotFoundError < StandardError
    def message
      "Queue doesn't exist"
    end
  end
end
