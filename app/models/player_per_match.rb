class PlayerPerMatch < ApplicationRecord
  belongs_to :player
  belongs_to :match

  validates :status, :position, presence: true

  before_create :set_position

  enum status: { confirmed: 0, waiting: 1, gived_up: 2 }

  def on_waiting_list?
    position > 24
  end

  private 

  def set_position
    self.position = match.next_available_position(player)
  end
end