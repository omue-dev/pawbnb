class Booking < ApplicationRecord
  belongs_to :user # guest
  belongs_to :hotel

  validates :start_date, :end_date, presence: true
  validates :status, inclusion: { in: %w[pending confirmed cancelled] }

  validate :end_after_start
  before_save :calculate_total_price

  private

  def end_after_start
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def calculate_total_price
    return unless start_date && end_date && hotel&.price_per_night

    days = (end_date - start_date).to_i
    self.total_price = days * hotel.price_per_night
  end
end
