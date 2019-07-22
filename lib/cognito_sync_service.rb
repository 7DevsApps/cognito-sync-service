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
  # attrs - hash of  user attributes which will be saved in cognito pool
  # cognito contain attributes in array of hashes format:
  # attrs = [
  #   {name: 'email', value: 'qwe@qwe,com'},
  #   {name: 'phone_number', value: '+12......0'}
  # ]
  def ca_create!(attrs, username)
    c_attributes = converted_attributes(attrs)
    cognito_provider.admin_create_user(user_pool_id: web_pool_id, username: username, user_attributes: c_attributes)
  end

  def ca_delete!(username)
    cognito_provider.admin_delete_user(user_pool_id: web_pool_id, username: username)
  end
end
