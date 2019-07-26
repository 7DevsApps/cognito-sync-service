# frozen_string_literal: true


# We assume that you will store your aws credentials in credentials.enc.yml or have similar file like credentials.yml
require 'yaml'
CREDENTIALS = YAML.load_file('spec/support/credentials.yml')

module CredentialsHelper
  def aws_provider
    ::Aws::CognitoIdentityProvider::Client.new(
      access_key_id: CREDENTIALS['development']['aws']['access_key_id'],
      secret_access_key: CREDENTIALS['development']['aws']['secret_access_key'],
      region: CREDENTIALS['development']['aws']['region']
    )
  end

  def pool_id
    CREDENTIALS['development']['aws']['pool_id']
  end

  def client_id
    CREDENTIALS['development']['aws']['client_id']
  end
end
