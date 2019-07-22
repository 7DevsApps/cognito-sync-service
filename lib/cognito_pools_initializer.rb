# frozen_string_literal: true

# TODO: add to credentials
# aws:
#  development:
#    web_pool: "web_pool_id"
#    web_client_id: "web_client_id"

module CognitoPoolsInitializer
  def web_pool_id(env_key = 'development')
    @web_pool_id ||= ENV[env_key]['aws']['web_pool']
  end

  def web_client_id(env_key = 'development')
    @web_client_id ||= ENV[env_key]['aws']['web_client_id']
  end
end
