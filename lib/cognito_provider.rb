# frozen_string_literal: true

# TODO: add to credentials
# aws:
#  access_key_id: "access_key_id"
#  secret_access_key: "secret_access_key"
#  region: "region"
#
module CognitoProvider
  def cognito_provider
    ::Aws::CognitoIdentityProvider::Client.new(
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
      region: Rails.application.credentials.dig(:aws, Rails.env.to_sym, :region)
    )
  end
end
