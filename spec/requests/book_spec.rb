require 'rails_helper'

describe "Books API", type: :request do
  let(:first_author) {FactoryBot.create(:author, first_name: 'george', last_name: 'drwell', age:47) }
  let(:second_author) {FactoryBot.create(:author, first_name: 'h.g', last_name: 'wells', age:78) }

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1984', author: first_author)
      FactoryBot.create(:book, title: 'the time machine', author: second_author)
    end
   it "returns all books" do
     get '/api/v1/books'

     expect(response).to have_http_status(:success)
     expect(response_body.size).to eq(2)
     expect(response_body).to eq(
      [
        {
        'id' => 1,
        'title' => '1984',
        'author_name' => 'george drwell',
        'author_age' => 47
        },
        {
          'id' => 2,
          'title' => 'the time machine',
          'author_name' => 'h.g wells',
          'author_age' => 78
          }
      ]
    )
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: { limit: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'title' => '1984',
            'author_name' => 'george drwell',
            'author_age' => 47
          }
        ]
      )
    end

    it 'returns a subset of books based on limit and offset' do
      get '/api/v1/books', params: { limit: 1, offset: 1 }

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq(
        [
          {
            'id' => 2,
            'title' => 'the time machine',
            'author_name' => 'h.g wells',
            'author_age' => 78
            }
        ]
      )
    end

    it 'has a max limit of 100' do
      expect(Book). to receive(:limit).with(100).and_call_original

      get '/api/v1/books', params: { limit: 999 }
    end
  end

  describe 'POST /books' do
    let!(:user) { FactoryBot.create(:user, password: 'password1') }

    it 'create a new book' do
      expect {
        post '/api/v1/books', params: {
          book: {title: 'the martian'},
          author: {first_name: 'andy', last_name: 'weir', age: '40'}
        }, headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg" }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          'id' => 1,
          'title' => 'the martian',
          'author_name' => 'andy weir',
          'author_age' => 40
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1984', author: first_author) }
    let!(:user) { FactoryBot.create(:user, password: 'password1') }

    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}",
        headers: { "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg" }
      }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end