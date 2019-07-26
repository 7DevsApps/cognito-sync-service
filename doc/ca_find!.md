# CognitoSyncService

__#ca_find!(username)__



> In order to create user on Cognito
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)

## Usage
```ruby
class UserExample 
  extend CognitoSyncService
end

UserExample.ca_find!('+123456789') => {"enabled"=>true,
                                       "phone_number"=>"+123456789", 
                                       "user_create_date"=>2019-07-26 15:48:06.130000114 +0300,
                                       "user_status"=>"FORCE_CHANGE_PASSWORD",
                                       "username"=>"dae4900d-0984-4ac0-9ab0-14505e52d50c"}
```
