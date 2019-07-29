# CognitoSyncService

__*#ca_delete!(username)*__

> Delete user from cognito pool.
>
> Also check this doc [admin-delete-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-delete-user.html) method

## Usage

```ruby

class UserExample
  extend ::CognitoSyncService
end

attrs = { phone_number: '+1111111111' }

UserExample.ca_create!(attrs, attrs[:phone_number]) =>
```

__Output__

```ruby
 {}
```
