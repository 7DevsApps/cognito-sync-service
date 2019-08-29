# frozen_string_literal: true

require 'cognito-sync-service.rb'

# rubocop:disable Metrics/BlockLength
RSpec.describe CognitoSyncService do
  before do
    allow(UserExample).to receive(:cognito_provider).and_return(aws_provider)
    allow(UserExample).to receive(:web_pool_id).and_return(pool_id)
    allow(UserExample).to receive(:web_client_id).and_return(client_id)
  end

  class UserExample
    extend ::CognitoSyncService
  end

  it 'has a version number' do
    expect(CognitoSyncService::VERSION).not_to be nil
  end

  describe '#ca_create!' do
    context 'with valid phone_number as username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user) { UserExample.ca_create!(attrs, phone_number) }

      it { expect(user.keys).to match_array(%w[enabled user_create_date user_last_modified_date user_status username phone_number]) }
      it { expect(user['phone_number']).to eq(phone_number) }

      after { UserExample.ca_delete!(phone_number) }
    end

    context 'with email as username and temporary password' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'Qazwsx-edc1!' }
      let!(:attrs) { { email: email } }
      let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }

      it { expect(UserExample.ca_initiate_auth!(email, temporary_password).challenge_name).to eq('NEW_PASSWORD_REQUIRED') }

      after { UserExample.ca_delete!(email) }
    end

    context 'with invalid email as username' do
      let!(:email) { "@invalid.email.com" }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Invalid email address format."
        end
      end
    end

    context 'with invalid username(numeric)' do
      let!(:email) { "12345" }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Username should be either an email or a phone number"
        end
      end
    end

    context 'with invalid password(too short)' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'zaza' }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email, temporary_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Password not long enough"
        end
      end
    end

    context 'with invalid password(only numbers)' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { '11111111111111111' }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email, temporary_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Password must have lowercase characters"
        end
      end
    end

    context 'with invalid password(only characters)' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'aADDSlkfdflkfddsDS' }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email, temporary_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Password must have numeric characters"
        end
      end
    end

    context 'with invalid password(only lowercase characters)' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'kskdsdksdkskdskdksd' }
      let!(:attrs) { { email: email } }

      it do
        expect { UserExample.ca_create!(attrs, email, temporary_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Password must have uppercase characters"
        end
      end
    end
  end

  describe '#ca_delete!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, phone_number) }

      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }

      it { expect(UserExample.ca_delete!(phone_number).to_h).to eq({}) }
    end

    context 'by nonexistent phone_number as username' do
      let!(:phone_number) { "+124423234252" }

      it do
        expect { UserExample.ca_delete!(phone_number) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::UserNotFoundException && error.message == "User not found."
        end
      end
    end
  end

  describe '#ca_find!' do
    context 'by phone_number as username' do
      before { UserExample.ca_create!(attrs, phone_number) }

      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user_keys) { UserExample.ca_find!(phone_number).keys }

      it { expect(user_keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status phone_number]) }

      after { UserExample.ca_delete!(phone_number) }
    end

    context 'by email as username' do
      before { UserExample.ca_create!(attrs, email) }

      let!(:email) { "qwe@qwe.com" }
      let!(:attrs) { { email: email } }
      let!(:user_keys) { UserExample.ca_find!(email).keys }

      it { expect(user_keys).to eq(%w[username user_create_date user_last_modified_date enabled user_status email]) }

      after { UserExample.ca_delete!(email) }
    end

    context 'by nonexistent email as username' do
      let!(:email) { 'qaaz@ads.com' }

      it do
        expect { UserExample.ca_find!(email) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::UserNotFoundException && error.message == "User not found."
        end
      end
    end
  end

  describe '#ca_disable!' do
    context 'by phone_number as username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user) { UserExample.ca_create!(attrs, phone_number) }

      it do
        expect(user['enabled']).to eq(true)
        UserExample.ca_disable!(phone_number)
        expect(UserExample.ca_find!(phone_number)['enabled']).to eq(false)
      end

      after { UserExample.ca_delete!(phone_number) }
    end

    context 'by nonexistent phone_number as username' do
      let!(:phone_number) { "+103030030303" }

      it do
        expect { UserExample.ca_disable!(phone_number) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::UserNotFoundException && error.message == "User not found."
        end
      end
    end
  end

  describe '#ca_enable!' do
    context 'by phone_number as username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let!(:user) { UserExample.ca_create!(attrs, phone_number) }
      let!(:disabled_user) { UserExample.ca_disable!(phone_number) }

      it do
        expect(UserExample.ca_find!(phone_number)['enabled']).to eq(false)
        UserExample.ca_enable!(phone_number)
        expect(UserExample.ca_find!(phone_number)['enabled']).to eq(true)
      end

      after { UserExample.ca_delete!(phone_number) }
    end

    context 'by nonexistent phone_number as username' do
      let!(:phone_number) { "+103030030303" }

      it do
        expect { UserExample.ca_enable!(phone_number) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::UserNotFoundException && error.message == "User not found."
        end
      end
    end
  end

  describe '#ca_update!' do
    let!(:phone_number) { "+111111111" }
    let!(:user) { UserExample.ca_create!({ email: "example1@gmail.com", phone_number: phone_number }, phone_number) }
    let!(:new_attrs) { { email: "example2@gmail.com" } }

    it 'should be change email attribute' do
      UserExample.ca_find!(phone_number)
      expect(user['email']).to eq("example1@gmail.com")
      expect(UserExample.ca_update!(new_attrs, phone_number)['email']).to eq("example2@gmail.com")
    end

    context 'update with invalid email' do
      let!(:invalid_attrs) { { email: "qwrrw.com21" } }

      it do
        expect { UserExample.ca_update!(invalid_attrs, phone_number) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Invalid email address format."
        end
      end
    end

    after { UserExample.ca_delete!(phone_number) }
  end

  describe '#ca_initiate_auth!' do
    context 'by email as username' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'Qazwsx-edc1!' }
      let!(:attrs) { { email: email } }
      let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }

      it { expect(UserExample.ca_initiate_auth!(email, temporary_password).challenge_name).to eq('NEW_PASSWORD_REQUIRED') }

      after { UserExample.ca_delete!(email) }
    end

    context 'by incorrect password' do
      let!(:email) { "q212e@qwe.com" }
      let!(:temporary_password) { 'Qazwsx-edc1!' }
      let!(:attrs) { { email: email } }
      let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }
      let!(:incorrect_password) { 'bbbbbbb' }

      it do
        expect { UserExample.ca_initiate_auth!(email, incorrect_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::NotAuthorizedException && error.message == "Incorrect username or password."
        end
      end

      after { UserExample.ca_delete!(email) }
    end
  end

  describe '#ca_respond_to_auth_challenge!' do
    context 'with valid data' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'Qazwsx-edc1!' }
      let!(:attrs) { { email: email } }
      let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }
      let!(:auth_response) { UserExample.ca_initiate_auth!(email, temporary_password) }

      it { expect(UserExample.ca_respond_to_auth_challenge!(email, temporary_password, auth_response.session).authentication_result.key?('access_token')).to eq(true) }

      after { UserExample.ca_delete!(email) }
    end

    context 'with invalid data' do
      let!(:email) { "qwe@qwe.com" }
      let!(:temporary_password) { 'Qazwsx-edc1!' }
      let!(:attrs) { { email: email } }
      let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }
      let!(:auth_response) { UserExample.ca_initiate_auth!(email, temporary_password) }

      it 'should raise Invalid session provided' do
        expect { UserExample.ca_respond_to_auth_challenge!(email, temporary_password, '4f43a5c946f33516bae12d81a39e3c40b55bb4f1') }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::CodeMismatchException && error.message == "Invalid session provided"
        end
      end

      after { UserExample.ca_delete!(email) }
    end
  end

  describe '#c_find_by_access_token!' do
    let!(:email) { "email@test.com" }
    let!(:temporary_password) { 'Qazwsx-edc1!' }
    let!(:attrs) { { email: email } }
    let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }
    let!(:init_auth) { UserExample.ca_initiate_auth!(email, temporary_password) }
    let!(:respond) { UserExample.ca_respond_to_auth_challenge!(email, temporary_password, init_auth.session) }

    it 'should fetch user by access token' do
      expect(UserExample.c_find_by_access_token!(respond.authentication_result.access_token).keys).to match_array(%w[username email])
    end

    it 'should raise Invalid Access Token' do
      expect { UserExample.c_find_by_access_token!('invalidAccessToken') }.to raise_error do |error|
        error == Aws::CognitoIdentityProvider::Errors::NotAuthorizedException && error.message == "Invalid Access Token"
      end
    end

    after { UserExample.ca_delete!(email) }
  end

  describe '#ca_refresh_tokens!' do
    before do
      UserExample.ca_create!(attrs, email, password)
      UserExample.ca_initiate_auth!(email, password)
    end

    let!(:email) { "qwe@aww.com" }
    let!(:password) { "Qazwsx-edc1!" }
    let!(:attrs) { { email: email } }
    let!(:session) { UserExample.ca_initiate_auth!(email, password).session }
    let!(:respond) { UserExample.ca_respond_to_auth_challenge!(email, password, session) }
    let!(:auth_result) { UserExample.ca_refresh_tokens!(respond.authentication_result.refresh_token).authentication_result }

    it 'should return refreshed access token' do
      expect(auth_result.access_token).to_not eq(respond.authentication_result.access_token)
    end

    it 'should return refreshed id token' do
      expect(auth_result.access_token).to_not eq(respond.authentication_result.id_token)
    end

    it 'should raise Invalid Refresh Token' do
      expect { UserExample.ca_refresh_tokens!('invalid_refresh_token') }.to raise_error do |error|
        error == Aws::CognitoIdentityProvider::Errors::NotAuthorizedException && error.message == "Invalid Refresh Token"
      end
    end

    after { UserExample.ca_delete!(email) }
  end

  describe '#ca_set_user_password!' do
    before { UserExample.ca_create!(attrs, email, old_password) }

    let!(:email) { "qwe@qwe.com" }
    let!(:attrs) { { email: email } }
    let!(:old_password) { "Qazwsx-edc1!" }
    let!(:new_password) { "Qwer-ty1!" }

    it 'should change password and status' do
      expect(UserExample.ca_find!(email)['user_status']).to eq("FORCE_CHANGE_PASSWORD")
      expect(UserExample.ca_set_user_password!(email, new_password)).to eq({})
      expect(UserExample.ca_initiate_auth!(email, new_password).challenge_name).to eq('NEW_PASSWORD_REQUIRED')
    end

    it 'should raise error User not found' do
      expect { UserExample.ca_set_user_password!('nonexistenst_username', new_password) }.to raise_error do |error|
        error == Aws::CognitoIdentityProvider::Errors::UserNotFoundException && error.message == "User not found."
      end
    end

    it 'should raise Password not too long' do
      expect { UserExample.ca_set_user_password!(email, 'tempo') }.to raise_error do |error|
        error == Aws::CognitoIdentityProvider::Errors::InvalidParameterException && error.message == "Password not long enough"
      end
    end

    after { UserExample.ca_delete!(email) }
  end
end
# rubocop:enable Metrics/BlockLength
