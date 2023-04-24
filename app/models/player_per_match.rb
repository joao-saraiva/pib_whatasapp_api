class PlayerPerMatch < ApplicationRecord
  belong_to :player
  belong_to :match

  validates :status, :position, presence: true

  before_create :set_position

  enum stauts: { confirmed: 0, waiting: 1, gived_up: 2 }

  def on_waiting_list?
    position > 24
  end

  private 

  def set_position
    self.position = match.player_per_matches.size + 1
  end
end