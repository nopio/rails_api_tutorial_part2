require 'rails_helper'

describe BookCopy do
  let(:user) { create(:user) }
  let(:book_copy) { create(:book_copy) }

  describe 'associations' do
    subject { book_copy }

    it { should belong_to(:book) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { book_copy }

    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:published) }
    it { should validate_presence_of(:format) }
    it { should validate_presence_of(:book) }
  end

  describe '#borrow' do
    context 'book is not borrowed' do
      subject { book_copy.borrow(user) }

      it { is_expected.to be_truthy }
    end

    context 'book is borrowed' do
      before { book_copy.update_column(:user_id, user.id)  }

      subject { book_copy.borrow(user) }

      it { is_expected.to be_falsy }
    end
  end

  describe '#return_book' do
    context 'book is borrowed' do
      before { book_copy.update_column(:user_id, user.id)  }

      subject { book_copy.return_book(user) }

      it { is_expected.to be_truthy }
    end

    context 'book is not borrowed' do
      subject { book_copy.return_book(user) }

      it { is_expected.to be_falsy }
    end
  end
end
