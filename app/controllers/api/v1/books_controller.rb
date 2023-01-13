module Api
  module V1
    class BooksController < ApplicationController
     before_action :set_book, only: [:show, :update, :destroy]

      def index
        @q = Book.ransack(params[:q])
        @books = @q.result

        render json: @books
      end

      def create
        @book = Book.new(book_params)

        if @book.save
          render json: @book, status: :created
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @book.destroy!

        head :no_content
      end

      private

        def set_book
          @book = Book.find(params[:id])
        end

        def book_params
          params.require(:book).permit(:title, :author_id)
        end
    end
  end
end