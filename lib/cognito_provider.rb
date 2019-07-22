# frozen_string_literal: true

# TODO: add to credentials on ENV
# development:
#   aws:
#   access_key_id: "access_key_id"
#   secret_access_key: "secret_access_key"
#   region: "region"

require 'aws-sdk-cognitoidentityprovider'

module CognitoProvider
  def cognito_provider(env_key = 'development')
    ::Aws::CognitoIdentityProvider::Client.new(
      access_key_id: ENV[env_key]['aws']['access_key_id'],
      secret_access_key: ENV[env_key]['aws']['secret_access_key'],
      region: ENV[env_key]['aws']['region']
    )
  end
  # If you store you env variables in credentials file for rails you should redefine cognito_provider like example bellow

  # def cognito_provider
  #   ::Aws::CognitoIdentityProvider::Client.new(
  #     access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
  #     secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
  #     region: Rails.application.credentials.dig(:aws, Rails.env.to_sym, :region)
  #   )
  # end
end

