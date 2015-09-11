require 'test_helper'

class Api::V1::TodosControllerTest < ActionController::TestCase

  def test_show_success
    todo = todos(:task1)
    get :show, id: todo.id
    assert_equal true, JSON.parse(@response.body)["success"]
  end

  def test_show_failure
    invalid_todo_id = 0
    get :show, id: invalid_todo_id
    assert_equal false, JSON.parse(@response.body)["success"]
    assert_equal "Todo with id #{invalid_todo_id} not found", JSON.parse(@response.body)["errors"]
  end

  def test_update_success
    assert_difference('Todo.count', 0) do
      put :update, id: todos(:task1).id, todo: {title: "Mark as done", done: true}
    end
    assert_equal true, JSON.parse(@response.body)["success"]
  end

  def test_delete_success
    assert_difference('Todo.count', -1) do
      delete :destroy, id: todos(:task1).id
    end
    assert_equal true, JSON.parse(@response.body)["success"]
  end

  def test_create_success
    assert_difference('Todo.count') do
      post :create, todo: {title: "Get milk", done: false}
    end
    assert_equal true, JSON.parse(@response.body)["success"]
  end
end
