require 'rails_helper'

describe User do
  let(:user) { create(:user) }

  describe 'associations' do
    subject { user }

    it { should have_many(:book_copies) }
  end

  describe 'validations' do
    subject { user }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
  end

  describe '#generate_api_key' do
    let(:user) { build(:user) }

    it 'is called before save' do
      expect(user).to receive(:generate_api_key)
      user.save
    end

    it 'generates random api key' do
      expect(user.api_key).to be_nil
      user.save
      expect(user.api_key).not_to be_nil
      expect(user.api_key.length).to eq(40)
    end
  end
end
