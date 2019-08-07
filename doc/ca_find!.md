# CognitoSyncService

__*#ca_find!(username)*__

### Synopsys

> In order to find user on Cognito pool
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)

Cognito return data in format with __user_attributes__ key
# cognito-idp example
```
<struct Aws::CognitoIdentityProvider::Types::AdminGetUserResponse
  username="98fa7330-a5bb-4aed-a89a-17eed002f238",
  user_attributes= [
    #<struct Aws::CognitoIdentityProvider::Types::AttributeType name="sub", value="98fa7330-a5bb-4aed-a89a-17eed002f238">,
    #<struct Aws::CognitoIdentityProvider::Types::AttributeType name="phone_number", value="+3333333333">
  ],
  user_create_date=2019-07-29 13:06:30 +0300,
  user_last_modified_date=2019-07-29 13:06:30 +0300,
  enabled=true,
  user_status="FORCE_CHANGE_PASSWORD",
  mfa_options=nil,
  preferred_mfa_setting=nil,
  user_mfa_setting_list=nil>

```
>
>
> Also check this doc [admin-get-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-get-user.html) method

## Usage

```ruby
class UserExample
  extend CognitoSyncService
end

UserExample.ca_find!('+123456789')
```

__Output__

```ruby
{
  "enabled"=>true,
  "phone_number"=>"+123456789",
  "user_create_date"=>2019-07-26 15:48:06.130000114 +0300,
  "user_status"=>"FORCE_CHANGE_PASSWORD",
  "username"=>"dae4900d-0984-4ac0-9ab0-14505e52d50c"
}
```
###In case of passing invalid or nonexistent(in your Cognito Pool) username you will get AWS error
```ruby
UserExample.ca_find!('invalid_username') #=> Aws::CognitoIdentityProvider::Errors::UserNotFoundException: User not found.
```
