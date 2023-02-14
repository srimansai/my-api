require "rails_helper"

 RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'GET index' do
    it 'has a max limit of 100' do
      expect(Book). to receive(:limit).with(100).and_call_original

      get :index, params: { limit: 999 }
    end
  end

  describe 'POST create' do
    let(:book_name) { 'harry potter' }
    let(:user) { FactoryBot.create(:user, password: 'password1') }

    context 'authorization header present' do
      before do
        allow(AuthenticationTokenService).to receive(:decode).and_return(user.id)
      end

     it 'calls UpdateSkuJob with correct params' do
       expect(UpdateSkuJob).to receive(:perform_later).with(book_name)

       post :create, params: {
         author: {first_name: 'jk', last_name: 'rowling', age: 40},
         book: {title: book_name}
        }
      end
    end

    context 'missing authorization header' do
      it 'returns a 401' do
        post :create, params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'missing authorization header' do
      let!(:book) { FactoryBot.create(:book, title: '1984', author: first_author) }
      let(:first_author) {FactoryBot.create(:author, first_name: 'george', last_name: 'drwell', age:47) }
      it 'returns a 401' do
        delete :destroy, params: { id: 1 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
