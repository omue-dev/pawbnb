class HotelsController < ApplicationController
  def index
    if params[:query].present?
      @hotels = Hotel.where("address ILIKE ?", "%#{params[:query]}%")
    else
      @hotels = Hotel.all
    end
  end

  def show
    @hotel = Hotel.find(params[:id])
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new()
    @hotel.save
  end
end
