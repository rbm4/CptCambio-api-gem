# CptCambioApiWrapper

"CptCambioApiWrapper" 
In this gem, you'll find the files you need to be able to package up your Ruby application a fully integration with the CptCambio Exchange API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'CptCambioApiWrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install CptCambioApiWrapper

## Usage
To use this the gem, initialize within a variable using your API keys, this method will mount for you a object wich will communicate with the API:

    client = CptCambioApiWrapper.init(key,secret)
    
Then you can use the operational methods

## User Info
Returns a JSON with the client's user information

    client.userInfo
    
## Instant buy price
Returns the actual price for buy/sell current open orders, given a pair and type ("buy","sell").

    client.instant_buy_price(currency1, currency2, type)
    client.instant_buy_price("DOGE", "BTC", "sell")
    
## List Orders
Returns a json with the user orders

    client.limit(limit)
    client.limit(100)
    
## Send order
Send an order, given pair, amount, price and type(buy / sell), return the JSON of the current open order

    client.send_order(pair,amount,price,type)
    client.send_order("DOGE/BTC",0.002,0.00000033,"buy")
    
    
## Cancel order
Cancel a given order by ID

    client.cancel_order(id)
    
## List deposits
Lists que user's deposit history limited to 100 maximum

    client.list_history(limit)

## List Withdrawals

    client.list_withdrawals(limit)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rbm4/CptCambio-api-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CptCambioApiWrapper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/CptCambioApiWrapper/blob/master/CODE_OF_CONDUCT.md).
