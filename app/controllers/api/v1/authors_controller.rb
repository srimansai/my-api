module Api
  module V1
    class AuthorsController < ApplicationController
     before_action :set_author, only: [:show, :update, :destroy]

      def index
        @q = Author.ransack(params[:q])
        @authors = @q.result

        render json: @authors
      end

      def create
        @author = Author.new(author_params)

        if @author.save
          render json: @author, status: :created
        else
          render json: @author.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @author.destroy!

        head :no_content
      end

      private

        def set_author
          @author = Author.find(params[:id])
        end

        def author_params
          params.require(:author).permit(:first_name, :last_name, :age)
        end
    end
  end
end