# CognitoSyncService

__*#ca_update!(username)*__

### Synopsys

> In order to update user on Cognito
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)
>
> Also check this doc [admin-update-user-attributes](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-update-user-attributes.html) method

## Usage

`Attention!!!`
changing username (alias for you login) not tested yet

```ruby
class UserExample
  extend ::CognitoSyncService
end

attrs = {
  { email: 'usernewemail@example.com' },
  { phone_number: '+1111111111' }
}

UserExample.ca_update!(attrs, attrs[:phone_number])
```

__Output__

```ruby
{
  "email"=>"example2@gmail.com",
  "username"=>"01f29e86-f9ff-4b30-a8d6-977e07d07abb",
  "user_create_date"=>2019-07-29 17:14:44 +0300,
  "user_last_modified_date"=>2019-07-29 17:15:04 +0300,
  "enabled"=>true,
  "user_status"=>"FORCE_CHANGE_PASSWORD",
  "phone_number"=>"+111111111"
}

```
