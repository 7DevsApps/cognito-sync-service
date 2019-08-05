# CognitoSyncService

Aws Cognito user pool synchronizer

- [CognitoSyncService](#cognitoSyncService)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Development](#development)
  - [Contributing](#contributing)
  - [Contacts](#contacts)
  - [License](#license)
  - [Status](#status)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito-sync-service', '~> 1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognito-sync-service

## Usage

[AWS Cognito](https://aws.amazon.com/ru/cognito/) let use [list of methods](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/index.html) or this [SDK  methods for ruby](https://docs.aws.amazon.com/sdkforruby/api/Aws/CognitoIdentity/Client.html).

In common case  you need __CRUD__ functionality, __synchronization__, between you DB and Cognito pools and __handling authorization__.

#### With this gem you can implement:
1. __CRUD__ functionality from you application
2. `(WIP)` __Synchronize__ you database users with user_pools
3. `(WIP)`__Handling authorization__


### Step 1
> Add required lib to you module or class
```ruby
require 'aws-sdk-cognitoidentityprovider'
```

> Create you __cognito provider__ method in this module for example
>
> for rails:
```ruby

def cognito_provider
  ::Aws::CognitoIdentityProvider::Client.new(
    access_key_id: Rails.application.credentials.dig(:access_key_id),
    secret_access_key: Rails.application.credentials.dig(:secret_access_key),
    region: Rails.application.credentials.dig(Rails.env.to_sym, :region)
  )
end
```
> or with `ENV` variables
```ruby
def cognito_provider
  ::Aws::CognitoIdentityProvider::Client.new(
    access_key_id: ENV['access_key_id'],
    secret_access_key: ENV['secret_access_key'],
    region: ENV['region']
  )
end
```
> or come up with any other way to implement the method __cognito_prodiver__
```ruby
def cognito_provider
	# your code
end
```

### Step 2
> Define two methods that will return `pool_id` and `cliend_pool_id` with `web_pool_id` and `web_client_id` names

```ruby
  def web_pool_id
    @web_pool_id ||= ENV['aws']['pool_id']
  end

  def web_client_id
    @web_client_id ||= ENV['aws']['client_id']
  end
```

> or come up with any other way to implement the method __cognito_prodiver__

```ruby
  def web_pool_id
    'us-east-1_DaexV9pOc' # Pool Id example
  end

  def web_client_id
    '6d1rss9carten3pkl0134658g5p' # Client id example
  end
```

### Step 3

> Above methods should be `extend` ~~not included~~  to you class
>
> In other words, the methods should be available to the `class` but not to the instance.

```ruby
# example with User class
User.cognito_provider # => #<Aws::CognitoIdentityProvider::Client>
User.web_poool_id # => 'us-east-1_DaexV9pOc'
User.web_client_id # => '6d1rss9carten3pkl0134658g5p'
```

### Step 4
> Add required lib to you class

```ruby
require 'cognito-sync-service'
```

> extend cognito sync service in you class

```ruby
extend CognitoSyncService
```

### Primitive example

```ruby
require 'aws-sdk-cognitoidentityprovider'
require 'cognito-sync-service'

class User
  extend CognitoSyncService

  def self.cognito_provider
    ::Aws::CognitoIdentityProvider::Client.new( access_key_id: "access_key_id", secret_access_key: "secret_access_key", region: "region")
  end

  def self.web_pool_id
    @web_pool_id ||= "pool_id"
  end

  def self.web_client_id
    @web_client_id ||= "client_id"
  end
end

User.ca_create!({phone_number: "+1111111111"}, "+1111111111")
# => {
#  "username"=>"fd09f027-bebf-4f43-abf9-248130145107f",
#  "user_create_date"=>2077-77-11 16:27:14 +0300,
#  "user_last_modified_date"=>2077-77-26 16:27:14 +0300,
#  "enabled"=>true,
#  "user_status"=>"FORCE_CHANGE_PASSWORD",
#  "phone_number"=>"+1111111111"
#}

```

## List of methods

*naming note:*
> methods naming was inspired by cognito naming but we added a prefix for a slight difference and changed the names to more understandable for ruby developers

`ca`_action => `cognito_admin`_action

`c`_action => `cognito`_action

 - [#ca_create!](doc/ca_create!.md)
 - [#ca_update!](doc/ca_update!.md)
 - [#ca_delete!](doc/ca_delete!.md)
 - [#ca_disable!](doc/ca_disable!.md)
 - [#ca_find!](doc/ca_find!.md)
 - [#ca_initiate_auth!](doc/ca_initiate_auth!.md)
 - [#ca_respond_to_auth_challenge!](doc/ca_respond_to_auth_challenge!.md)

## Development

See [DEVELOPMENT.md](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/DEVELOPMENT.md).

## Contributing

See [CONTRIBUTING.md](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CognitoSyncService project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/CODE_OF_CONDUCT.md).
## Contacts

https://7devs.co/contact?section=contact-form
https://t.me/hakmatmao

## Status
[![Maintainability](https://api.codeclimate.com/v1/badges/b90c232e049a226e25d9/maintainability)](https://codeclimate.com/github/MarkOsipenko/cognito-sync-service/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b90c232e049a226e25d9/test_coverage)](https://codeclimate.com/github/MarkOsipenko/cognito-sync-service/test_coverage)
