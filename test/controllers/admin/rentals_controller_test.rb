require 'test_helper'

class Admin::RentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_rentals_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_rentals_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_rentals_edit_url
    assert_response :success
  end

end
