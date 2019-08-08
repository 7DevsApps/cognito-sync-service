# CognitoSyncService

## [WIP] Now used [hardcoded challenge_name](https://github.com/MarkOsipenko/cognito-sync-service/blob/master/lib/cognito-sync-service.rb#L66) inside __#ca_respond_to_auth_challenge!__. We expect this method will be more flexible in future

__*#ca_respond_to_auth_challenge!(username, password, session)*__

__Note:__

>The session is issued by calling #ca_initiate_auth! method.

### Synopsys

> In order to confirm account status by password, as an administrator on Cognito
> - Username should be equal __email/phone_number/random_uniq_string__ depend on you cognito user pool settings - [cognito username attribute doc](https://docs.aws.amazon.com/en_us/cognito/latest/developerguide/user-pool-settings-attributes.html#user-pool-settings-usernames)
>
> Also check this doc [admin-respond-to-auth-challenge](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-respond-to-auth-challenge.html) method

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

result = UserExample.ca_respond_to_auth_challenge!(username, password, session)
```

__Output__

```ruby
#<struct Aws::CognitoIdentityProvider::Types::AdminRespondToAuthChallengeResponse
  session=nil,
  challenge_parameters={},
  challenge_name=nil,
  authentication_result=
  #<struct Aws::CognitoIdentityProvider::Types::AuthenticationResultType
    access_token= "eyJraWQiOiJ3T0RTTmYyTXRheDJPM24lD2xMc1RoM1hoOXV6V3BBcEpubjdMMlwvMXo4bz0iLCJhbGciOiJSUzI1NiJ9cHgmlc6WWxXPw36GuQ91jiTisnvtJWus-XvOOcLK4qsQ",
    expires_in=3600,
    token_type="Bearer",
    refresh_token= "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2-Dmc6dms9iukp_YUfeO6Vj-P9sOom_khf3FWTMz1Mb2dI8vjhvG_kK8Gu-5rw",
    id_token= "eyJraWQiOiJSejZRdXRPbXVlNk1vdEZpUm83M1lsTWJSZjc4Qxv4MUk0K29BeDhRNmxzPSIsImFsZyI6IlJTMjU2In0.hftrLf9--JjgZYAREDXYM8aJkLkeuXCSnM5fkOqYn8DQ",
    new_device_metadata=nil
  >
>
```
__Note:__

> If you need to retreive `access_token` or `id_token` from ```result``` you can simply call it by its keys like:

```ruby
result.authentication_result.access_token 
#=> "eyJraWQiOiJ3T0RTTmYyTXRheDJPM24lD2xMc1RoM1hoOXV6V3BBcEpubjdMMlwvMXo4bz0iLCJhbGciOiJSUzI1NiJ9cHgmlc6WWxXPw36GuQ91jiTisnvtJWus-"

result.authentication_result.id_token 
#=> "eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2-Dmc6dms9iukp_YUfeO6Vj-P9sOom_khf3FWTMz1Mb2dI8vjhvG_kK8Gu-5rw" 
```

__Error output__

In case of passing invalid session you will get AWS error

```ruby
UserExample.ca_respond_to_auth_challenge!(username, password, 'invalid_session')
#=> Aws::CognitoIdentityProvider::Errors::CodeMismatchException: Invalid session provided
```
