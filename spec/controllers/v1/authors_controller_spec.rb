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

  end
end
