class Match < ApplicationRecord
  validates :status, :date, presence: true

  enum status: { open: 0, closed: 1, cancelled: 2 }
end
