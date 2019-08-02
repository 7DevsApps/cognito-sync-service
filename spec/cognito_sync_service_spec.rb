# frozen_string_literal: true

require 'cognito-sync-service.rb'

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
    context 'with valid phone_number in username' do
      let!(:phone_number) { "+3333333333" }
      let!(:attrs) { { phone_number: phone_number } }
      let(:user) { UserExample.ca_create!(attrs, phone_number) }

      it { expect(user.keys).to match_array(%w[enabled user_create_date user_last_modified_date user_status username phone_number]) }
      it { expect(user['phone_number']).to eq(phone_number) }

      after { UserExample.ca_delete!(phone_number) }
    end

    xcontext 'with temporary password' do
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

  describe '#ca_update!' do
    let(:phone_number) { "+111111111" }
    let!(:user) { UserExample.ca_create!({ email: "example1@gmail.com", phone_number: phone_number }, phone_number) }
    let!(:new_attrs) { { email: "example2@gmail.com" } }

    it 'should be change email attribute' do
      UserExample.ca_find!(phone_number)
      expect(user['email']).to eq("example1@gmail.com")
      expect(UserExample.ca_update!(new_attrs, phone_number)['email']).to eq("example2@gmail.com")
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
        binding.pry
        expect { UserExample.ca_initiate_auth!(email, incorrect_password) }.to raise_error do |error|
          error == Aws::CognitoIdentityProvider::Errors::NotAuthorizedException && error.message == "Incorrect username or password."
        end
      end

      after { UserExample.ca_delete!(email) }
    end
  end

  describe '#ca_respond_to_auth_challenge!' do
    let!(:email) { "qwe@qwe.com" }
    let!(:temporary_password) { 'Qazwsx-edc1!' }
    let!(:attrs) { { email: email } }
    let!(:user) { UserExample.ca_create!(attrs, email, temporary_password) }
    let!(:auth_response) { UserExample.ca_initiate_auth!(email, temporary_password) }

    it { expect(UserExample.ca_respond_to_auth_challenge!(email, temporary_password, auth_response.session).authentication_result.key?('access_token')).to eq(true) }

    after { UserExample.ca_delete!(email) }
  end
end
