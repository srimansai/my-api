require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get title" do
    get books_title_url
    assert_response :success
  end

  test "should get author" do
    get books_author_url
    assert_response :success
  end

end
