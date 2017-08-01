require "smart_que/version"
require "smart_que/config"
require "smart_que/errors"
require "smart_que/publisher"

require "bunny"
require "yaml"
require "json"
require "logger"

module SmartQue
  # Methods related to configurations
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config) if block_given?
    config
  end

  # Establish bunny connection
  def self.establish_connection
    return @conn if @conn

    @conn ||= Bunny.new(
      host: config.host,
      port: config.port,
      username: config.username,
      password: config.password)

    @conn.start
    @conn
  end

  # Logger
  def self.log(data)
    env = ENV['RAILS_ENV'] || config.env

    proc = Proc.new do
      if config.logger
        @logger = config.logger
      else
        logfile = config.logfile || "log/smart_que.log"
        @logger = Logger.new(logfile, 'weekly')
      end
    end


    return if (env == 'testing' or env == 'test')

    @logger ||= proc.call

    @logger.info(data.inspect)
  end
end
