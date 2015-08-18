class CatRentalRequestsController < ApplicationController
  def index
    @cat_rental_requests = CatRentalRequest.all
    @cats = @cat_rental_requests.map { |request| Cat.find(request.cat_id) }
    render :index
    # @cat_names = Cat.all.map { |cat| cat.name}
  end

  def show
    @cat_rental_request = CatRentalRequest.find(params[:id])
    cat_id = @cat_rental_request.cat_id
    @cat = Cat.find(cat_id)
    render :show
  end

  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_rental_request_url(@cat_rental_request)
    else
      render :new
    end
  end

  def edit
    @cat_rental_request = CatRentalRequest.find(params[:id])
  end

  def update
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.update(cat_rental_request_params)
    redirect_to cat_rental_request_url(@cat_rental_request)
  end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
