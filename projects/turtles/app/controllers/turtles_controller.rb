class TurtlesController < ApplicationController
  def create
    @turtle = Turtle.new(turtle_params)
    if @turtle.save
      redirect_to("/turtles")
    else
      flash[:errors] = ["Invalid turtle information."]
      render :new
    end
  end

  def index
    @turtles = Turtle.all
    render :index
  end

  def new
    @turtle = Turtle.new
    render :new
  end

  private

  def turtle_params
    params["turtle"]
  end
end
