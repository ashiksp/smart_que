require "smart_que/version"
require "smart_que/config"
require "smart_que/errors"
require "smart_que/publisher"
require "smart_que/consumer"

require "bunny"
require "yaml"
require "json"
require "logger"
require 'fileutils'

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
        logfile = config.logfile || default_log_file
        @logger = Logger.new(logfile, 'weekly')
      end
    end


    return if (env == 'testing' or env == 'test')

    @logger ||= proc.call

    @logger.info(data.inspect)
  end

  def self.default_log_file
    log_file = "log/smart_que.log"
    dir = File.dirname(log_file)
    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end
    log_file
  end
end
