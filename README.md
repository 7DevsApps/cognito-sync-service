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
gem 'cognito-sync-service'
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
*methods naming:*

`ca`_action => `cognito_admin`_action

`c`_action => `cognito`_action

## Development

See [DEVELOPMENT.md](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/DEVELOPMENT.md).

## Contributing

See [CONTRIBUTING.md](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CognitoSyncService project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MarkOsipenko/cognito_sync_service/blob/master/CODE_OF_CONDUCT.md).
## Contacts

https://t.me/hakmatmao


## Status
[![Maintainability](https://api.codeclimate.com/v1/badges/b90c232e049a226e25d9/maintainability)](https://codeclimate.com/github/MarkOsipenko/cognito-sync-service/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b90c232e049a226e25d9/test_coverage)](https://codeclimate.com/github/MarkOsipenko/cognito-sync-service/test_coverage)
