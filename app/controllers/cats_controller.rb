class CatsController < ApplicationController
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @requests = @cat.cat_rental_requests.sort_by {|request| request.start_date}
    render :show
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update(cat_params)
    redirect_to cat_url(@cat)
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :sex, :description, :color)
  end
end
