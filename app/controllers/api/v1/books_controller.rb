module Api
  module V1
    class BooksController < ApplicationController
     include ActionController::HttpAuthentication::Token

     before_action :set_book, only: [:show, :update, :destroy]
     before_action :authenticate_user, only: [:create, :destroy]
     MAX_PAGTNATION_LIMIT = 100
      def index
        #@q = Book.ransack(params[:q])
        #@books = @q.result
        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).as_json
      end

      def create
        author = Author.create!(author_params)
        book = Book.new(book_params.merge(author_id: author.id))

        UpdateSkuJob.perform_later(book_params[:title])


        if book.save
          render json: BookRepresenter.new(book).as_json, status: :created
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @book.destroy!

        head :no_content
      end

      private

       def authenticate_user
         # Authorization: Bearer <token>
         token, _options = token_and_options(request)
         user_id = AuthenticationTokenService.decode(token)
         User.find(user_id)
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          render status: :unauthorized
        end

        def limit
          [
            params.fetch(:limit, MAX_PAGTNATION_LIMIT).to_i,
            MAX_PAGTNATION_LIMIT
          ].min
        end

        def set_book
          @book = Book.find(params[:id])
        end

        def book_params
          params.require(:book).permit(:title, :author_id)
        end

        def author_params
          params.require(:author).permit(:first_name, :last_name, :age)
        end
    end
  end
end