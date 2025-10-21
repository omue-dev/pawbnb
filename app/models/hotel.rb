class Hotel < ApplicationRecord
  # Associations
  belongs_to :user # host
  has_many :bookings, dependent: :destroy
  has_one_attached :photo

  # Validations
  validates :name, :description, :address, :price_per_night, presence: true
  validates :price_per_night, numericality: { greater_than: 0 }

  # Instance methods
  def formatted_price
    # Displays something like "€89.95" or "$89.95"
    # hotel.formatted_price => "€89.95"
    sprintf("€%.2f", price_per_night)
  end
end
