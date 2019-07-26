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

  def convert_from_cognito(user_struct)
    cognito_attrs = user_struct.to_h

    user_attributes(cognito_attrs)
  end

  def user_attributes(cognito_attrs)
    if cognito_attrs.key?(:user_attributes)
      user_attrs = cognito_attrs.delete(:user_attributes)
      common_attrs = cognito_attrs
    elsif cognito_attrs.key?(:attributes)
      user_attrs = cognito_attrs.delete(:attributes)
      common_attrs = cognito_attrs
    end

    list_cognito_attr_keys.map do |key|
      (user_attrs.find do |a|
        common_attrs[key.to_s] = a[:value] if a[:name] == cognito_key_name(key)
      end)
    end

    Hash[common_attrs.map { |k, v| [k.to_s, v] }]
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
