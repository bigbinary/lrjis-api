class Api::V1::TodosController < Api::V1::BaseController

  before_action :verify_api_key_present
  before_action :set_todo_user
  before_action :ensure_todo_user_present
  before_action :set_todo, only: [:show, :update, :destroy]
  before_action :fail_if_invalid_todo_id, only: [:show, :update, :destroy]

  def show
    render json: {todo: {title: @todo.title, done: @todo.done}}, status: :ok
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: {success: true}, status: :ok
    else
      render json: {success: false, errors: todo.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: {success: true}, status: :ok
    else
      render json: {success: false, errors: @todo.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @todo.destroy
      render json: {success: true}, status: :ok
    else
      render json: {success: false, errors: @todo.errors}, status: :unprocessable_entity
    end
  end

  private

  def set_todo
    @todo = Todo.find_by_id(params[:id])
  end

  def fail_if_invalid_todo_id
    render json: {errors: "Todo with id #{params[:id]} not found"}, status: :not_found if @todo.nil?
  end

  def todo_params
    params.require(:todo).permit(:title, :done).merge(user: @todo_user)
  end

  def verify_api_key_present
    render json: { error: "No API key attached" }, status: 422 unless params[:api_key]
  end

  def set_todo_user
    @todo_user ||= User.find_by_api_key(params[:api_key])
  end

  def ensure_todo_user_present
    render json: { error: "Invalid API Key" }, status: 401 unless @todo_user
  end

end
