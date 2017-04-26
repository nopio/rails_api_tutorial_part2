require 'rails_helper'

describe Author do
  subject { create(:author) }

  describe 'associations' do
    it { should have_many(:books) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end
