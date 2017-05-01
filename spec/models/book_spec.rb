require 'rails_helper'

describe Book do
  let(:book) { create(:book) }

  describe 'associations' do
    subject { book }

    it { should have_many(:book_copies) }
    it { should belong_to(:author) }
  end

  describe 'validations' do
    subject { book }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
  end

  describe '.per_page' do
    subject { described_class.per_page }

    it { is_expected.to eq(20) }
  end
end
