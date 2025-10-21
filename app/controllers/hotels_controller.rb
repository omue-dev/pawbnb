class HotelsController < ApplicationController
  def index
    @hotels = Hotel.all
  end

  def new
    @hotel = Hotel.new
  end

  def create 
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      redirect_to @hotel, notice: "Hotel created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
      
  end

  private 

  def hotel_params
     params.require(:hotel).permit(:name, :description, :address, :price_per_night, photos: [])
  end
end
