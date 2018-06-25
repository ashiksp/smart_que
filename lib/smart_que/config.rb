module SmartQue
  class Config
    # Configurations
    # allowed configurations
    CONFIGURATION = %w(host vhost port queues env username password logfile logger)

    # Initialize
    def initialize
      @config = {}
      load_configuration_from_yml
    end

    def method_missing(name, *args)
      setter = false

      name = name.to_s

      if name =~ /=$/
        name = name.to_s.chop
        setter = true
      end

      super(name, args) unless CONFIGURATION.include?(name)

      if setter
        set(name, args.first)
      else
        get(name)
      end
    end

    private

    def load_configuration_from_yml
      if File.exist? 'config/smart_que.yml'
        @config = YAML.load(File.read('config/smart_que.yml')) || @config
      end
    end

    def set(key, val)
      @config[key] = val
    end

    def get(key)
      @config[key]
    end
  end
end