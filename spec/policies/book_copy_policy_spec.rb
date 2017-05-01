require 'rails_helper'

describe BookCopyPolicy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :return_book? do
    context 'as admin' do
      it 'grants access if user is an admin' do
        expect(subject).to permit(Contexts::UserContext.new(nil, User.new(admin: true)), BookCopy.new)
      end
    end

    context 'as user' do
      it 'denies access if book_copy is not borrowed' do
        expect(subject).not_to permit(Contexts::UserContext.new(User.new, nil), BookCopy.new)
      end

      it 'grants access if book_copy is borrowed by a user' do
        expect(subject).to permit(Contexts::UserContext.new(user, nil), BookCopy.new(user: user))
      end
    end
  end
end
