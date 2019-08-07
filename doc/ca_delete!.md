# CognitoSyncService

__*#ca_delete!(username)*__

### Synopsys

> Delete user from cognito pool.
>
> Also check this doc [admin-delete-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-delete-user.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

UserExample.ca_delete!(username)
```

__Output__

```ruby
 {}
```

__Error output__

### In case of passing invalid or nonexistent(in your Cognito Pool) username you will get AWS error

```ruby
UserExample.ca_delete!('invalid_username')
#=> Aws::CognitoIdentityProvider::Errors::UserNotFoundException: User not found.
```
