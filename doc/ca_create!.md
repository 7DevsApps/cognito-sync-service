# CognitoSyncService

__*#ca_create!(username)*__

### Synopsys

> In order to create user on Cognito
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)
> - The user's temporary password must conform to the password policy that you specified when you created the user pool. The temporary password is valid only once. To complete the Admin Create User flow, the user must enter the temporary password in the sign-in page along with a new password to be used in all future sign-ins. This parameter is not required.

> Also check this doc [admin-create-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-create-user.html) method
## Usage
```ruby
class UserExample
  extend ::CognitoSyncService
end

attrs = {
  { email: 'useremail@example.com' },
  { phone_number: '+1111111111' }
}

UserExample.ca_create!(attrs, attrs[:phone_number])
```
__Output__

```ruby
{
  "username"=>"fd99f027-bebf-4f43-abf9-24829f45107f",
  "user_create_date"=>2019-07-26 16:27:14 +0300,
  "user_last_modified_date"=>2019-07-26 16:27:14 +0300,
  "enabled"=>true,
  "user_status"=>"FORCE_CHANGE_PASSWORD",
  "phone_number"=>"+3333333333"
}
```
###In case of passing invalid email as username you will get AWS error
```ruby
invalid_email = '@invalid.email.com'
invalid_attrs = { { email: invalid_email } }

UserExample.ca_create!(invalid_attrs, invalid_email) #=> Aws::CognitoIdentityProvider::Errors::InvalidParameterException: Invalid email address format.
```
###Depending on your Cognito User Pool settings – you will get different validation messages
_For example minimum password length set to 8 characters_
```ruby
invalid_password = '123abc'
attrs = {
  { email: 'useremail@example.com' },
  { phone_number: '+1111111111' }
}

UserExample.ca_create!(attrs, attrs[:phone_number], invalid_password) #=> Aws::CognitoIdentityProvider::Errors::InvalidParameterException: Password not long enough
```
_For example password requires numbers_
```ruby
invalid_password = 'qwerty'
attrs = {
  { email: 'useremail@example.com' },
  { phone_number: '+1111111111' }
}

UserExample.ca_create!(attrs, attrs[:phone_number], invalid_password) #=> Aws::CognitoIdentityProvider::Errors::InvalidParameterException: Password must have numeric characters
```
