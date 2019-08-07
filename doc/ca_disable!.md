# CognitoSyncService

__*#ca_disable!(username)*__

### Synopsys

> Disable user in cognito pool.
>
> Also check this doc [admin-disable-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-disable-user.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

UserExample.ca_disable!(username)
```

__Output__

```ruby
 {}
```

###In case of passing invalid or nonexistent(in your Cognito Pool) username you will get AWS error

```ruby
UserExample.ca_disable!('invalid_username') #=> Aws::CognitoIdentityProvider::Errors::UserNotFoundException: User not found.
```
