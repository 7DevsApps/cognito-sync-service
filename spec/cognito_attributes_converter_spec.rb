# frozen_string_literal: true

require 'pry'
require 'cognito_attributes_converter.rb'

RSpec.describe CognitoAttributesConverter do
  class UserExample
    include ::CognitoAttributesConverter

    def cognito_custom_attr_keys
      [:disabled_at, "restored_at"]
    end
  end

  describe '.convert_to_cognito' do
    let(:attrs1) { { email: "sample@gmail.com", phone_number: "+3123123123", disabled_at: "2020-10-10", restored_at: "2020-10-10" } }
    let(:attrs2) { { "email" => "sample@gmail.com", "phone_number" => "+3123123123", "disabled_at" => "2020-10-10", "restored_at" => "2020-10-10"} }

    let(:user) { UserExample.new }
    let(:cognito_attrs1) {
      [
        {"name" => "email",        "value" => "sample@gmail.com"},
        {"name" => "phone_number", "value" => "+3123123123"},
        {"name" => "custom:disabled_at",  "value" => "2020-10-10"},
        {"name" => "custom:restored_at",  "value" => "2020-10-10"}
      ]
    }

    context do
      it { expect(user.convert_to_cognito(attrs1)).to eq(cognito_attrs1) }
      it { expect(user.convert_to_cognito(attrs2)).to eq(cognito_attrs1) }
    end
  end
end
