# frozen_string_literal: true

require 'cognito_attributes_converter.rb'

module AttributesConverterHelper
  include ::CognitoAttributesConverter
  def convert_from_cognito(user_struct)
    cognito_attrs = if user_struct.user.to_h.key?(:user_attributes)
                      user_struct.user.user_attributes
                    else
                      user_struct.user.attributes
                    end

    attrs = OpenStruct.new
    list_cognito_attr_keys.map do |key|
      (cognito_attrs.find do |a|
        attrs[key] = a.value if a[:name] == cognito_key_name(key)
      end)
    end

    attrs
  end
end
