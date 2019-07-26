# frozen_string_literal: true

require 'cognito_attributes_converter.rb'

RSpec.describe CognitoAttributesConverter do
  class UserExample
    extend ::CognitoSyncService
    include ::CognitoAttributesConverter
    include ::CognitoProvider
    include ::CognitoPoolsInitializer

    def cognito_default_attr_keys
      [:email, "phone_number"]
    end

    def cognito_custom_attr_keys
      [:disabled_at, "restored_at", "has_picture"]
    end
  end

  let(:user) { UserExample.new }

  describe '.converted_attributes' do
    context 'convert attributes to cognito' do
      let(:attrs1) do
        {
          email: "sample@gmail.com",
          phone_number: "+3123123123",
          disabled_at: "2020-10-10",
          restored_at: "2020-10-10",
          has_picture: true,
          not_white_list_attr: 1
        }
      end

      let(:attrs2) do
        {
          "email" => "sample@gmail.com",
          "phone_number" => "+3123123123",
          "disabled_at" => "2020-10-10",
          "restored_at" => "2020-10-10",
          "has_picture" => true,
          "not_white_list_attr" => 1
        }
      end

      let(:cognito_attrs1) do
        [
          { name: "email",              value: "sample@gmail.com" },
          { name: "phone_number",       value: "+3123123123" },
          { name: "custom:disabled_at", value: "2020-10-10" },
          { name: "custom:restored_at", value: "2020-10-10" },
          { name: "custom:has_picture", value: true }
        ]
      end

      context 'white list attributes' do
        it { expect(user.converted_attributes(attrs1)).to eq(cognito_attrs1) }
        it { expect(user.converted_attributes(attrs2)).to eq(cognito_attrs1) }
      end
    end
  end

  describe '.convert_to_cognito' do
    let(:attrs1) do
      {
        email: "sample@gmail.com",
        phone_number: "+3123123123",
        disabled_at: "2020-10-10",
        restored_at: "2020-10-10",
        has_picture: true,
        not_white_list_attr: 1
      }
    end

    let(:attrs2) do
      {
        "email" => "sample@gmail.com",
        "phone_number" => "+3123123123",
        "disabled_at" => "2020-10-10",
        "restored_at" => "2020-10-10",
        "has_picture" => true,
        "not_white_list_attr" => 1
      }
    end

    let(:cognito_attrs1) do
      [
        { name: "email",              value: "sample@gmail.com" },
        { name: "phone_number",       value: "+3123123123" },
        { name: "custom:disabled_at", value: "2020-10-10" },
        { name: "custom:restored_at", value: "2020-10-10" },
        { name: "custom:has_picture", value: true }
      ]
    end

    context 'white list attributes' do
      it { expect(user.convert_to_cognito(attrs1)).to eq(cognito_attrs1) }
      it { expect(user.convert_to_cognito(attrs2)).to eq(cognito_attrs1) }
    end
  end

  describe '.user_attributes' do
    before { UserExample.ca_create!(attrs, username) }
    let!(:username) { "+3333333333" }
    let!(:attrs) { { phone_number: username } }
    let(:user) { UserExample.cognito_provider.admin_get_user(user_pool_id: UserExample.web_pool_id, username: username).to_h }

    it { expect(UserExample.user_attributes(user).keys).to match_array(%w[phone_number enabled user_last_modified_date user_create_date user_status username]) }

    after { UserExample.ca_delete!(username) }
  end

  describe '.convert_from_cognito' do
    before { UserExample.ca_create!(attrs, username) }
    let!(:username) { "+3333333333" }
    let!(:attrs) { { phone_number: username } }
    let(:user) { UserExample.cognito_provider.admin_get_user(user_pool_id: UserExample.web_pool_id, username: username) }

    it { expect(UserExample.convert_from_cognito(user).keys).to match_array(%w[phone_number enabled user_last_modified_date user_create_date user_status username]) }

    after { UserExample.ca_delete!(username) }
  end

  describe '.cognito_key_name' do
    it { expect(user.cognito_key_name(:email)).to eq("email") }
    it { expect(user.cognito_key_name("phone_number")).to eq("phone_number") }
    it { expect(user.cognito_key_name("phone_number")).to eq("phone_number") }
    it { expect(user.cognito_key_name(:disabled_at)).to eq("custom:disabled_at") }
    it { expect(user.cognito_key_name("disabled_at")).to eq("custom:disabled_at") }
  end

  describe '.cognito_key?' do
    it { expect(user.cognito_key?(:email)).to eq(true) }
    it { expect(user.cognito_key?("phone_number")).to eq(true) }
    it { expect(user.cognito_key?("not_white_list_attr")).to eq(false) }
  end

  describe '.list_cognito_attr_keys' do
    it { expect(user.list_cognito_attr_keys).to match_array(%w[email phone_number disabled_at restored_at has_picture]) }
  end

  describe '.cognito_custom_attr_keys' do
    it { expect(user.cognito_custom_attr_keys).to match_array([:disabled_at, "restored_at", "has_picture"]) }
  end

  describe '.cognito_default_attr_keys' do
    it { expect(user.cognito_default_attr_keys).to match_array([:email, "phone_number"]) }
  end

  describe '.list_cognito_custom_attr_keys' do
    it { expect(user.list_cognito_custom_attr_keys).to match_array(%w[disabled_at restored_at has_picture]) }
  end

  describe '.list_cognito_default_attr_keys' do
    it { expect(user.list_cognito_default_attr_keys).to match_array(%w[email phone_number]) }
  end
end
