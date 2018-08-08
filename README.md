# SmartQue

Welcome to SmartQue gem! This gem uses bunny library to connect with RabbitMq message broker
to publish and consume messages with defined queues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart-que', '~> 0.2.6'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart-que -v 0.2.6

## Usage

1. Setup [RabbitMq](https://www.rabbitmq.com/#getstarted)
2. Add `smart-que` gem to your Gemfile and perform bundle install
3. Require `smart_que` in the application.rb file
4. Create Publisher/Consumer classes & start publish/consume messages

## SmartQue Publisher

SmartQue publisher is used to publish messages to the previously setup RabbitMq
server. All messages are converted to JSON format before publishing to the queue.
RabbitMq server details and queue lists can be configured as follows

```
# File: config/initializers/smart_que.rb
require 'smart_que'

SmartQue.configure do |f|
  f.host = ENV[:rabbit_mq][:host']
  f.port = ENV[:rabbit_mq][:port']
  f.vhost = ENV[:rabbit_mq][:vhost']
  f.username = ENV[:rabbit_mq][:username']
  f.password = ENV[:rabbit_mq][:password']
  f.logger = Rails.logger
  f.queues = [
      'default',
      'sms_otp',
      'fcm_push'
  ]
end

$publisher = SmartQue::Publisher.new

# Add this below mentioned line to your application.rb
# File : config/application.rb

require 'smart_que'
```

After initializing SmartQue publisher, it can be accessed anywhere in the rails application
to publish messages to the RabbitMq server.

```
$publisher.publish('sms_otp', { number: '+919898123123', message: 'Test Message' })
```


## SmartQue unicast

```
$publisher.unicast(queue_name, payload)
```

The `unicast` method will provide an option to publish message to any queue which are
not predefined with initialization configuration. The `queue_name` parameter can be any queue
name, which will be created and bound to direct exchange instantly if doesn't exist.

```
$publisher.unicast('sms_alert', { number: '+919898123123', message: 'Test Message' })
```



## SmartQue multicast

```
$publisher.multicast(topic_name, payload)
```

The `multicast` method will provide an option to multicast message to queues which are
not predefined with initialization configuration. The `topic_name` parameter can be any
topic name and message will be consumable by any queues which subscribe to this topic
name.

```
$publisher.multicast('weather', { message: 'Test Message' })
```

## SmartQue broadcast

```
$publisher.broadcast(payload)
```

The `broadcast` method will provide an option to broadcast message to queues which are
not predefined with initialization configuration. The broadcst message will be consumable by
all queues which are bound to rabbitmq fanout exchange.

```
$publisher.broadcast({ message: 'Broadcast Test Message' })
```


## SmartQue Consumer

The consumer class should be inherited from SmartQue::Consumer, and each consumer will be
listening to a defined Queue. The queue name and `run` method should be defined properly
in each consumer class.

```
class OtpSmsConsumer < SmartQue::Consumer
  QUEUE_NAME = 'sms.otp'

  def run(payload)
    # Payload: { number: '+919898123123', message: 'Test Message' }
    # Method implementation goes here
    puts payload
  end
end
```

Note that, queue name words are separated by `.` while defining it with consumer class.
Consumer can be started by calling `start` method available for consumer instance as follows

```
c = OtpSmsConsumer.new
c.start
```

All consumer processes can be placed in a rake file, so that it can be started individually
with rake tasks.

```
File : lib/tasks/consumer.rake

# Tasks which related to rabbitmq broker.
namespace :rabbitmq do

  desc "Run OTP sms worker"
  task :send_otp_sms => [:environment] do
    c = OtpSmsConsumer.new
    c.start
  end
end

# Task can be initiated by rake
RAILS_ENV=staging bundle exec rake rabbitmq:send_otp_sms
```

## SmartQue Exceptions

SmartQue will not retry automatic connection recovery after rabbitmq connection failure. It raises
`SmartQue::ConnectionError` when tcp connection failure happens. You can catch this exception to
identify connection failures and can perform necessary actions upon it.

## RabbitMq Web Interface

You can enable rabbitmq_management plugin so that rabbitmq server informations
are viewed and managed via web console interface. Management plugin can be enabled
by running this command and can be accessed through [web browser](localhost:15672)

```
rabbitmq-plugins enable rabbitmq_management
```

More informations are available on RabbitMq [management plugin documentations](https://www.rabbitmq.com/management.html).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smart_que. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SmartQue project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/smart_que/blob/master/CODE_OF_CONDUCT.md).
