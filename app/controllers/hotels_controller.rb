class HotelsController < ApplicationController
  def index
    @hotels = Hotel.all
  end
end
