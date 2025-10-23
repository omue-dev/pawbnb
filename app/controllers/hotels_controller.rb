class HotelsController < ApplicationController
  def index
    @hotels = Hotel.all
  end

  def new 
    @hotel = Hotel.new
  end

  def create 
    @hotel = Hotel.new()
    @hotel.save
  end
end
