require 'rails_helper'

describe Author do
  let(:author) { create(:author) }

  describe 'associations' do
    subject { author }

    it { should have_many(:books) }
  end

  describe 'validations' do
    subject { author }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end
