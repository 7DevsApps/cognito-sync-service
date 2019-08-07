# CognitoSyncService

__*#ca_enable!(username)*__

### Synopsys

> Enable user in cognito pool.
>
> Also check this doc [admin-enable-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-enable-user.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

UserExample.ca_enable!(username)
```

__Output__

```ruby
 {}
```

__Error output__

In case of passing invalid or nonexistent(in your Cognito Pool) username you will get AWS error

```ruby
UserExample.ca_enable!('invalid_username')
#=> Aws::CognitoIdentityProvider::Errors::UserNotFoundException: User not found.
```
