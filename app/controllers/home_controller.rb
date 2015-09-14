class HomeController < ApplicationController

  def index
    @todos = current_user.todos.order(:id)
  end

end
