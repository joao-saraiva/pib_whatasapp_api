# frozen_string_literal: true

class PlayerPerMatch < ApplicationRecord
  attr_accessor :player_number, :player_name, :player_pib_priority
  include AASM

  belongs_to :player
  belongs_to :match

  validates :status, :position, presence: true

  before_validation :set_match_and_player, if: :new_record?
  before_validation :set_position_and_status, if: :new_record?

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

  def set_position_and_status
    self.position = match.next_available_position(player)
    self.status = self.position > 24 ? :waiting : :confirmed
  end

  def set_match_and_player
    self.match_id = Match.open.last&.id
    self.player_id = Player.find_by("number IS NOT NULL and number = ?", player_number)&.id
    
    if self.player_id.nil?
      self.player_id = Player.create(number: player_number, name: player_name, pib_priority: player_pib_priority)&.id
    else
      player.update_attribute(:pib_priority, player_pib_priority)
    end

    if self.match_id.nil?
      self.match_id = Match.create(status: :open, date: Date.today)&.id
    end
  end
end
