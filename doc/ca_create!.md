# CognitoSyncService

__#ca_create!(username)__



> Create user from you ruby project
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)

## Example
```ruby
class UserExample
  extend ::CognitoSyncService
end

attrs = [
  { email: 'useremail@example.com' },
  { phone_number: '+1111111111' }
]

UserExample.ca_create!(attrs, attrs[:phone_number]) => {
                                                          "username"=>"fd99f027-bebf-4f43-abf9-24829f45107f",
                                                          "user_create_date"=>2019-07-26 16:27:14 +0300,
                                                          "user_last_modified_date"=>2019-07-26 16:27:14 +0300,
                                                          "enabled"=>true,
                                                          "user_status"=>"FORCE_CHANGE_PASSWORD",
                                                          "phone_number"=>"+3333333333"
                                                        }

```
