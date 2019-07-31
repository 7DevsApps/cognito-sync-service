# CognitoSyncService

__*#ca_initiate_auth!(username, password)*__

> In order to perform the authentication flow, as an administrator on Cognito
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)
>
> Also check this doc [admin-initiate-auth](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-initiate-auth.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

result = UserExample.ca_initiate_auth!(username, password)
```

__Output__

```ruby
{
  #<struct Aws::CognitoIdentityProvider::Types::AdminInitiateAuthResponse
   challenge_name="NEW_PASSWORD_REQUIRED",
   session="E_-IQ-PFywvo2Q0_od1LFrIc5VxsNuMVq_Idjwvry8wmmtwKri2my2VJwr7tu45jXucSwIG0SRzestDK13slda_fdRR_AkNLsBT9AMqKtm7avy6Dq0QRKOjBdnjsMEKn4bClX9LO",
   challenge_parameters={"USER_ID_FOR_SRP"=>"bbd455ea-e07a-382d-a7b5-7f04ef8827aa", "requiredAttributes"=>"[]", "userAttributes"=>"{\"email\":\"qwe@qwe.com\"}"},
   authentication_result=nil>
}
```

__Note:__
> if you need to retreive values from auth_result you can simply call it by its keys like:
```ruby 
result.challenge_name #=> "NEW_PASSWORD_REQUIRED"
result.session #=> "E_-IQ-PFywvo2Q0_od1LFrIc5VxsNuMVq_Idjwvry8wmmtwKri2my2VJwr7tu45jXucSwIG0SRzestDK13slda_fdRR_AkNLsBT9AMqKtm7avy6Dq0QRKOjBdnjsMEKn4bClX9LO"
result.challenge_parameters #=> {"USER_ID_FOR_SRP"=>"bbd455ea-e07a-382d-a7b5-7f04ef8827aa", "requiredAttributes"=>"[]", "userAttributes"=>"{\"email\":\"qwe@qwe.com\"}"}
result.authentication_result #=> nil
```
>In this case ```authentication_result``` is ```nil``` because of particular auth flow when user account in Cognito has not been confirmed yet.
```authentication_result``` is only returned if the caller does not need to pass another challenge. If the caller does need to pass another challenge before it gets tokens, ChallengeName , ChallengeParameters , and Session are returned.

