# frozen_string_literal: true

require 'aws-sdk-cognitoidentityprovider'
# We assume that you will store your aws credentials in .env file

module CredentialsHelper
  def aws_provider
    ::Aws::CognitoIdentityProvider::Client.new(
      access_key_id: ENV['ACCESS_KEY_ID'],
      secret_access_key: ENV['SECRET_ACCESS_KEY'],
      region: ENV['REGION']
    )
  end

  def pool_id
    ENV['POOL_ID']
  end

  def client_id
    ENV['CLIENT_ID']
  end
end
