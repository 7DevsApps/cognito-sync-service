# CognitoSyncService

__*#c_find_by_access_token!(access_token)*__

### Synopsys

> In order to fetch user on Cognito pool by access token
> - The access token returned by the server response to get information about the user.

Cognito return data in format with __user_attributes__ key

# cognito-idp example

```
#<struct Aws::CognitoIdentityProvider::Types::GetUserResponse
 username="ba9faac3-2291-4f56-9c6b-a85471445726",
 user_attributes=[#<struct Aws::CognitoIdentityProvider::Types::AttributeType name="sub", value="ba9faac3-2291-4f56-9c6b-a85471445726">, #<struct Aws::CognitoIdentityProvider::Types::AttributeType name="email", value="email@test.com">],
 mfa_options=nil,
 preferred_mfa_setting=nil,
 user_mfa_setting_list=nil>
```

> Also check this doc [get-user](https://docs.aws.amazon.com/cli/latest/reference/cognito-idp/get-user.html) method

## Usage

```ruby
class UserExample
  extend CognitoSyncService
end

UserExample.c_find_by_access_token!("iOiJKV1QiLCJlbmMiOiJBMjU2-Dmc6dms9iukp_YUfeO6Vj-P9sOom_khf3FWTMz1Mb2dI8v")
```

__Output__

```ruby
{
  "email"=>"email@test.com",
  "username"=>"dae4900d-0984-4ac0-9ab0-14505e52d50c"
}
```

__Error output__

In case of passing invalid access token you will get AWS error

```ruby
UserExample.c_find_by_access_token!("invalid_access_token")
#=> Aws::CognitoIdentityProvider::Errors::NotAuthorizedException: Invalid Access Token
```
