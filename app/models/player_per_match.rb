# frozen_string_literal: true

class PlayerPerMatch < ApplicationRecord
  include AASM

  belongs_to :player
  belongs_to :match

  validates :status, :position, presence: true

  before_create :set_position

  delegate :name, to: :player
  scope :not_confimed, lambda {
                         where.not(status: PlayerPerMatch.statuses[:confirmed])
                       }
  scope :avaliable, lambda {
                      where(status: [PlayerPerMatch.statuses[:confirmed], PlayerPerMatch.statuses[:waiting]])
                    }

  scope :pib_priority, -> { joins(:player).where(player: { pib_priority: true }) }
  scope :non_pib_priority, -> { joins(:player).where(player: { pib_priority: [nil, false] }) }
  enum status: { confirmed: 0, waiting: 1, gived_up: 2 }

  aasm column: 'status', enum: true do
    state :confirmed, initial: true
    state :waiting
    state :gived_up

    event :give_up do
      transitions from: %i[confirmed waiting], to: :gived_up

      after do
        match.player_per_matches.avaliable.where('position > ?',
                                                 position).update_all('position = position - 1')
      end
    end

    event :confirm do
      transitions from: :waiting, to: :confirmed
    end
  end

  def on_waiting_list?
    position > 24
  end

  def list_line
    "#{position} - #{name}\n"
  end

  private

  def set_position
    self.position = match.next_available_position(player)
  end
end
