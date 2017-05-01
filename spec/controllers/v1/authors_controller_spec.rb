require 'rails_helper'

describe V1::AuthorsController do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:author) { create(:author) }

  before { request.env['HTTP_AUTHORIZATION'] = "Token token=#{api_key}" }

  describe '#index' do
    subject { get :index }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      before { author }

      it { is_expected.to be_successful }
      it 'returns valid JSON' do
        body = JSON.parse(subject.body)
        expect(body['authors'].length).to eq(1)
        expect(body['meta']['pagination']).to be_present
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#show' do
    subject { get :show, params: { id: author.id } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it { is_expected.to be_successful }

      it 'returns valid JSON' do
        subject
        expect(response.body).to eq({ author: AuthorSerializer.new(author).attributes }.to_json)
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#create' do
    let(:author_params) { { first_name: 'First name' } }

    subject { post :create, params: { author: author_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:author_params) { { first_name: 'First name', last_name: 'Last name' } }

        it { is_expected.to be_created }

        it 'creates an author' do
          expect { subject }.to change(Author, :count).by(1)
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
    let(:author_params) { {} }

    subject { put :update, params: { id: author.id, author: author_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:author_params) { { first_name: 'Foo' } }

        it 'updates requested record' do
          subject
          expect(author.reload.first_name).to eq(author_params[:first_name])
          expect(response.body).to eq({ author: AuthorSerializer.new(author.reload).attributes }.to_json)
        end

        it { is_expected.to be_successful }
      end

      context 'with invalid params' do
        let(:author_params) { { first_name: nil } }

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: author.id } }

    before { author }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it 'removes requested record' do
        expect { subject }.to change(Author, :count).by(-1)
      end

      it { is_expected.to be_no_content }
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end
end
