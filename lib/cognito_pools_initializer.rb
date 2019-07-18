# frozen_string_literal: true

# TODO: add to credentials
# aws:
#  development:
#    web_pool: "web_pool_id"
#    web_client_id: "web_client_id"

module CognitoPoolsInitializer
  def web_pool_id
    @web_pool_id ||= Rails.application.credentials.dig(Rails.env.to_sym, :aws, :web_pool)
  end

  def web_client_id
    @web_client_id ||= Rails.application.credentials.dig(Rails.env.to_sym, :aws, :web_client_id)
  end
end
