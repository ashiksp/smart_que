module SmartQue
  class QueueNotFoundError < StandardError
    def message
      "Queue doesn't exist"
    end
  end

  class ConnectionError < StandardError
    def message
      "Broken connection failed"
    end
  end
end
