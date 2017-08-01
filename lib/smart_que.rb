require "smart_que/version"
require "smart_que/config"

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
end
