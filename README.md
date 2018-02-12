# SmartQue

Welcome to SmartQue gem! This gem uses bunny library to connect with RabbitMq message broker
to publish and consume messages with defined queues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart-que'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart-que

## Usage

TODO: Write usage instructions here

1. Setup [RabbitMq](https://www.rabbitmq.com/#getstarted)
2. Add `smart-que` gem to your Gemfile and perform bundle install
3. Create Publisher/Consumer classes & start publish/consume messages

## SmartQue Publisher

SmartQue publisher is used to publish messages to the previously setup RabbitMq
server. All messages are converted to JSON format before publishing to the queue.
RabbitMq server details and queue lists can be configured as follows

```
file: config/initializers/smart_que.rb

SmartQue.configure do |f|
  f.host = ENV[:rabbit_mq][:host']
  f.port = ENV[:rabbit_mq][:port']
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

```

After initializing SmartQue publisher, it can be accessed anywhere in the rails application
to publish messages to the RabbitMq server.

```
$publisher.publish('sms_otp', { number: '+919898123123', message: 'Test Message' })
```

## SmartQue Consumer

Need to update this section


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smart_que. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SmartQue project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/smart_que/blob/master/CODE_OF_CONDUCT.md).
