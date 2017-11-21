class Booking < ApplicationRecord
  belongs_to :rental

  validates :price, :rental_id, :start_at, presence: true
  validates :end_at, { after_or_equal_to:  :start_at}, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :client_email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }


end
