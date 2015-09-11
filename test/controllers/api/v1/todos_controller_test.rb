require 'test_helper'

class Api::V1::TodosControllerTest < ActionController::TestCase

  def setup
    @user = users(:admin)
  end

  def test_index_success
    get :index, api_key: @user.api_key
    assert_equal 200, response.status
  end

  def test_show_success
    todo = todos(:task1)
    get :show, id: todo.id, api_key: @user.api_key
    assert_equal 200, response.status
  end

  def test_show_failure
    invalid_todo_id = 0
    get :show, id: invalid_todo_id, api_key: @user.api_key
    assert_equal "Todo with id #{invalid_todo_id} not found", JSON.parse(response.body)["errors"]
    assert_equal 404, response.status
  end

  def test_update_success
    assert_difference('Todo.count', 0) do
      put :update, id: todos(:task1).id, todo: {title: "Mark as done", done: true}, api_key: @user.api_key
    end
    assert_equal true, JSON.parse(response.body)["success"]
    assert_equal 200, response.status
  end

  def test_delete_success
    assert_difference('Todo.count', -1) do
      delete :destroy, id: todos(:task1).id, api_key: @user.api_key
    end
    assert_equal true, JSON.parse(response.body)["success"]
    assert_equal 200, response.status
  end

  def test_create_success
    assert_difference('Todo.count') do
      post :create, todo: {title: "Get milk", done: false, user: @user}, api_key: @user.api_key
    end
    assert_equal true, JSON.parse(response.body)["success"]
    assert_equal 200, response.status
  end
end
