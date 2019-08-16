# CognitoSyncService

__*#ca_set_user_password!(username, password)*__

### Synopsys

> Sets the specified user's password in a user pool as an administrator. Works on any user.
>
> Also check AWS API Documentation [AdminSetUserPassword](https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_AdminSetUserPassword.html) method
>
> Also check this doc [admin-set-user-password](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-set-user-password.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

UserExample.ca_set_user_password!(username, password)
```

__Output__

```ruby
#<struct Aws::CognitoIdentityProvider::Types::AdminSetUserPasswordResponse>
```

__Error output__

In case of passing invalid or nonexistent(in your Cognito Pool) username you will get AWS error

```ruby
UserExample.ca_set_user_password!('invalid_username', password)
#=> Aws::CognitoIdentityProvider::Errors::UserNotFoundException: User not found.
```
