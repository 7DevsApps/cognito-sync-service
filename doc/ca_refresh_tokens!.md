# CognitoSyncService

__*#ca_refresh_tokens!(refresh_token)*__

### Synopsys

> Authentication flow for refreshing the Access token and ID token by supplying a valid refresh token.
>
> Also check this doc [admin-initiate-auth](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/admin-enable-user.html) method. Pay attention to description about REFRESH_TOKEN_AUTH authentication flow.

## Usage

```ruby
class UserExample
  extend ::CognitoSyncService
end

result = UserExample.ca_refresh_tokens!(refresh_token)
```

__Output__

```ruby
 #<struct Aws::CognitoIdentityProvider::Types::AdminInitiateAuthResponse
  challenge_name=nil,
  session=nil,
  challenge_parameters={},
  authentication_result=
   #<struct Aws::CognitoIdentityProvider::Types::AuthenticationResultType
    access_token=
     "eyJraWQiOiJ3T0RTTmYyTXRheDJPMTVOS2xMc1RoM1hoOXV6V3BBcEpMUk0K29BeDhRNmxzPSIsImFsZHN1U6fbXscuMGeogaR-",
    expires_in=3600,
    token_type="Bearer",
    refresh_token=nil,
    id_token=
     "eyJraWQiOiJSejZRdXRPbXVlNk1vdEZpUm83M1lsTWeyJraWQiOiJ3T0RTTmYyTXRheDJPMTVOS2xMc1",
    new_device_metadata=nil>>
```

__Note:__

> If you need to retreive `access_token` or `id_token` from ```result``` you can simply call it by its keys like:

```ruby
result.authentication_result.access_token 
#=> "eyJraWQiOiJ3T0RTTmYyTXRheDJPMTVOS2xMc1RoM1hoOXV6V3BBcEpMUk0K29BeDhRNmxzPSIsImFsZHN1U6fbXscuMGeogaR-"

result.authentication_result.id_token 
#=> "eyJraWQiOiJSejZRdXRPbXVlNk1vdEZpUm83M1lsTWeyJraWQiOiJ3T0RTTmYyTXRheDJPMTVOS2xMc1" 
```

>In this case ```challenge_name```,`session` and `challenge_parameters` return ```nil``` because of particular auth flow when Access token and ID token have been refreshed successfully.
>
>So when the caller does need to pass another challenge before it gets tokens, `challenge_name`, `challenge_parameters`, and `session` are returned.

__Error output__

In case of passing invalid Refresh token you will get AWS error

```ruby
UserExample.ca_refresh_tokens!('invalid_refresh_token')
#=> Aws::CognitoIdentityProvider::Errors::NotAuthorizedException: Invalid Refresh Token.
```
