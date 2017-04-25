module V1
  class BookCopiesController < ApplicationController
    skip_before_action :authenticate_admin, only: [:return_book, :borrow]
    before_action :authenticate, only: [:return_book, :borrow]
    before_action :current_user_presence, only: [:return_book, :borrow]
    before_action :set_book_copy, only: [:show, :destroy, :update, :borrow, :return_book]

    def index
      book_copies = BookCopy.preload(:book, :user, book: [:author]).paginate(page: params[:page])
      render json: book_copies, meta: pagination(book_copies), adapter: :json
    end

    def show
      render json: @book_copy, adapter: :json
    end

    def create
      book_copy = BookCopy.new(book_copy_params)
      if book_copy.save
        render json: book_copy, adapter: :json, status: 201
      else
        render json: { error: book_copy.errors }, status: 422
      end
    end

    def update
      if @book_copy.update(book_copy_params)
        render json: @book_copy, adapter: :json, status: 200
      else
        render json: { error: @book_copy.errors }, status: 422
      end
    end

    def destroy
      @book_copy.destroy
      head 204
    end

    def borrow
      if @book_copy.borrow(current_user)
        render json: @book_copy, adapter: :json, status: 200
      else
        render json: { error: 'Cannot borrow this book.' }, status: 422
      end
    end

    def return_book
      authorize(@book_copy)

      if @book_copy.return_book(current_user)
        render json: @book_copy, adapter: :json, status: 200
      else
        render json: { error: 'Cannot return this book.' }, status: 422
      end
    end

    private

    def set_book_copy
      @book_copy = BookCopy.find(params[:id])
    end

    def book_copy_params
      params.require(:book_copy).permit(:book_id, :format, :isbn, :published, :user_id)
    end
  end
end
