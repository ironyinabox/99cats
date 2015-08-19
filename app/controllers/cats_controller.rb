class CatsController < ApplicationController
  before_action :redirect_if_unauthorized, only: [:edit, :update]

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
    @cat.user_id = current_user.id
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

  def current_user_is_owner?
    Cat.find(params[:id]).user_id == current_user.id
  end

  def redirect_if_unauthorized
    redirect_to cats_url unless current_user_is_owner?
  end
end
