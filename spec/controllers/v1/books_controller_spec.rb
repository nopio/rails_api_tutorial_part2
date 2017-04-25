require 'rails_helper'

describe V1::BooksController do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:author) { create(:author) }

  before { request.env['HTTP_AUTHORIZATION'] = "Token token=#{api_key}" }

  describe '#index' do
    subject { get :index }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      before { book }

      it { is_expected.to be_successful }
      it 'returns valid JSON' do
        body = JSON.parse(subject.body)
        expect(body['books'].length).to eq(1)
        expect(body['meta']['pagination']).to be_present
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#show' do
    subject { get :show, params: { id: book.id } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it { is_expected.to be_successful }

      it 'returns valid JSON' do
        subject
        expect(response.body).to eq({ book: BookSerializer.new(book).attributes }.to_json)
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#create' do
    let(:book_params) { { title: nil } }

    subject { post :create, params: { book: book_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:book_params) { { title: 'Title', author_id: author.id } }

        it { is_expected.to be_created }

        it 'creates a book' do
          expect { subject }.to change(Book, :count).by(1)
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
    let(:book_params) { {} }

    subject { put :update, params: { id: book.id, book: book_params } }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      context 'with valid params' do
        let(:book_params) { { title: 'Title' } }

        it 'updates requested record' do
          subject
          expect(book.reload.title).to eq(book_params[:title])
          expect(response.body).to eq({ book: BookSerializer.new(book.reload).attributes }.to_json)
        end

        it { is_expected.to be_successful }
      end

      context 'with invalid params' do
        let(:book_params) { { title: nil } }

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { id: book.id } }

    before { book }

    context 'as admin' do
      let(:api_key) { admin.api_key }

      it 'removes requested record' do
        expect { subject }.to change(Book, :count).by(-1)
      end

      it { is_expected.to be_no_content }
    end

    context 'as user' do
      let(:api_key) { user.api_key }

      it { is_expected.to be_unauthorized }
    end
  end
end
