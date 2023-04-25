class PlayerPerMatch < ApplicationRecord
  include AASM

  belongs_to :player
  belongs_to :match

  validates :status, :position, presence: true

  before_create :set_position

  scope :avaliable, -> { where(status: [PlayerPerMatch.statuses[:confirmed], PlayerPerMatch.statuses[:waiting]]) }
  enum status: { confirmed: 0, waiting: 1, gived_up: 2 }

  aasm column: 'status', enum: true do 
    state :confirmed, initial: true
    state :waiting
    state :gived_up

    event :give_up do
      transitions from: [:confirmed, :waiting], to: :gived_up

      after do 
        match.player_per_matches.avaliable.where("position > ?", position).update_all("position = position - 1")
      end
    end
  end

  def on_waiting_list?
    position > 24
  end

  private 

  def set_position
    self.position = match.next_available_position(player)
  end
end