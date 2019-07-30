# frozen_string_literal: true

require 'cognito_sync_service/version'
require 'cognito_attributes_converter.rb'
require 'cognito_pools_initializer.rb'
require 'cognito_provider.rb'

module CognitoSyncService
  include ::CognitoAttributesConverter
  include ::CognitoPoolsInitializer
  include ::CognitoProvider

  # username - can be email, phone_number or custom string depend on you cognito pool settings
  # attrs - hash of user attributes which will be saved in cognito pool
  # attrs = { email: 'qwe@qwe,com', phone_number:  '+12......0'}
  def ca_create!(attrs, username, temporary_password=nil)
    c_attributes = convert_to_cognito(attrs)
    user = cognito_provider.admin_create_user(user_pool_id: web_pool_id, username: username, user_attributes: c_attributes, temporary_password: temporary_password).user
    convert_from_cognito(user)
  end

  # user can be delete by email or phone_number depend on cognito pool settings
  def ca_delete!(username)
    cognito_provider.admin_delete_user(user_pool_id: web_pool_id, username: username)
  end

  # user can be find by email or phone_number depend on cognito pool settings
  def ca_find!(username)
    user = cognito_provider.admin_get_user(user_pool_id: web_pool_id, username: username)
    convert_from_cognito(user)
  end

  # username - can be email, phone_number or custom string depend on cognito pool settings
  # attrs - hash of user attributes which will be saved in cognito pool
  # attrs = { email: 'qwe@qwe,com', phone_number:  '+12......0'}
  def ca_update!(attrs, username)
    c_attributes = convert_to_cognito(attrs)
    cognito_provider.admin_update_user_attributes(user_pool_id: web_pool_id, username: username, user_attributes: c_attributes)
    ca_find!(username)
  end

  # user can be disable by email or phone_number depend on cognito pool settings
  def ca_disable!(username)
    cognito_provider.admin_disable_user(user_pool_id: web_pool_id, username: username)
  end

  # user can be authenticated by email or phone_number depend on cognito pool settings
  def ca_initiate_auth!(username, password)
    cognito_provider.admin_initiate_auth(
      user_pool_id: web_pool_id,
      client_id: web_client_id,
      auth_flow: 'ADMIN_NO_SRP_AUTH',
      auth_parameters: {
        USERNAME: username,
        PASSWORD: password
      }
    )
  end
end
