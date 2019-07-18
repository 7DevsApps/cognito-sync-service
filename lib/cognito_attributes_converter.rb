# frozen_string_literal: true

module CognitoAttributesConverter
  attr_reader :attributes, :new_attrs

  def convert_to_cognito(attrs, new_attrs = {})
    cognito_attrs = attrs.merge(new_attrs).map { |k, v| [k.to_s, v] }.to_h

    cognito_attrs.map do |k, v|
      { "name" => cognito_key_name(k), "value" => v } if cognito_key?(k) && v
    end.compact
  end

  def cognito_key_name(key)
    return "custom:#{key}" if cognito_custom_attr_keys.map(&:to_s).include?(key)

    key
  end

  def cognito_key?(key)
    cognito_attr_keys.include?(key)
  end

  def camel_case(k)
    k = k.split("_").map(&:capitalize).join
    # k[0] = k[0].downcase
    k
  end

  def cognito_attr_keys
    cognito_default_attr_keys.map(&:to_s) + cognito_custom_attr_keys.map(&:to_s)
  end

  def cognito_default_attr_keys
    %w[email phone_number] # username should not be in user_attributes hash, see CognitoService.rb:7
  end

  def cognito_custom_attr_keys
    %w[]
  end
end
