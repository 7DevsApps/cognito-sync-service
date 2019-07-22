# frozen_string_literal: true

module CognitoAttributesConverter
  def converted_attributes(attrs)
    convert_to_cognito(attrs)
  end

  def convert_to_cognito(attrs)
    cognito_attrs = attrs.map { |k, v| [k, v] }.to_h

    cognito_attrs.map do |k, v|
      { name: cognito_key_name(k), value: v } if cognito_key?(k) && v
    end.compact
  end

  # name of attribute in cognito pool
  def cognito_key_name(key)
    return "custom:#{key}" if list_cognito_custom_attr_keys.include?(key.to_s)

    key.to_s
  end

  def cognito_key?(key)
    list_cognito_attr_keys.include?(key.to_s)
  end

  def list_cognito_attr_keys
    list_cognito_default_attr_keys + list_cognito_custom_attr_keys
  end

  def list_cognito_default_attr_keys
    cognito_default_attr_keys.map(&:to_s)
  end

  def list_cognito_custom_attr_keys
    cognito_custom_attr_keys.map(&:to_s)
  end

  # redefine this methods in you model if you want to store special attributes
  def cognito_default_attr_keys
    %w[email phone_number]
  end

  # redefine this methods in you model if you want to store special custom attributes
  def cognito_custom_attr_keys
    %w[]
  end
end
