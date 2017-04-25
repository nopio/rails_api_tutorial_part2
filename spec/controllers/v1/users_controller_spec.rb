require 'rails_helper'

describe V1::UsersController do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  before { request.env['HTTP_AUTHORIZATION'] = "Token token=#{api_key}" }

  describe '#index' do
    subject { get :index }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      before { user }

      it { is_expected.to be_successful }
      it 'returns valid JSON' do
        body = JSON.parse(subject.body)
        expect(body['users'].length).to eq(2)
        expect(body['meta']['pagination']).to be_present
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#show' do
    subject { get :show, params: { id: user.id } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it { is_expected.to be_successful }

      it 'returns valid JSON' do
        subject
        expect(response.body).to eq({ user: UserSerializer.new(user).attributes }.to_json)
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#create' do
    let(:user_params) { { first_name: nil } }

    subject { post :create, params: { user: user_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:user_params) { { first_name: 'Name', last_name: 'Last', email: 'foo@bar.com' } }

        it { is_expected.to be_created }

        it 'creates a user' do
          expect { subject }.to change(User, :count).by(1)
        end
      end

      context 'with invalid params' do
        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#update' do
    let(:user_params) { {} }

    subject { put :update, params: { id: user.id, user: user_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:user_params) { { last_name: 'Last' } }

        it 'updates requested record' do
          subject
          expect(user.reload.last_name).to eq(user_params[:last_name])
          expect(response.body).to eq({ user: UserSerializer.new(user.reload).attributes }.to_json)
        end

        it { is_expected.to be_successful }
      end

      context 'with invalid params' do
        let(:user_params) { { first_name: nil } }

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: user.id } }

    before { user }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it 'removes requested record' do
        expect { subject }.to change(User, :count).by(-1)
      end

      it { is_expected.to be_no_content }
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end
end
