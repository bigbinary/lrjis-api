class Api::V1::TodosController < Api::V1::BaseController

  before_action :set_todo, only: [:show, :update, :destroy]
  before_action :fail_if_invalid_todo_id, only: [:show, :update, :destroy]

  def show
    render json: {success: true, todo: {title: @todo.title, done: @todo.done}}
  end

  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: {success: true}
    else
      render json: {success: false, errors: todo.errors}
    end
  end

  def update
    if @todo.update(todo_params)
      render json: {success: true}
    else
      render json: {success: false, errors: @todo.errors}
    end
  end

  def destroy
    if @todo.destroy
      render json: {success: true}
    else
      render json: {success: false, errors: @todo.errors}
    end
  end

  private

  def set_todo
    @todo = Todo.find_by_id(params[:id])
  end

  def fail_if_invalid_todo_id
    render json: {success: false, errors: "Todo with id #{params[:id]} not found"} if @todo.nil?
  end

  def todo_params
    params.require(:todo).permit(:title, :done)
  end

end
