# frozen_string_literal: true

class PlayerPerMatch < ApplicationRecord
  attr_accessor :player_number, :player_name, :player_pib_priority, :friend_name
  include AASM

  belongs_to :player
  belongs_to :match

  validates :position, presence: true

  before_validation :set_player, if: :new_record?
  before_validation :set_match, if: :new_record?
  before_validation :set_position_and_status, if: :new_record?

  delegate :name, to: :player

  scope :pib_priority, -> { joins(:player).where(player: { pib_priority: true }) }
  scope :non_pib_priority, -> { joins(:player).where(player: { pib_priority: [nil, false] }) }

  def on_waiting_list?
    position > 24
  end

  def list_line
    "#{position} - #{name}\n"
  end

  def give_up!
    match.player_per_matches.where('position > ?', position).update_all('position = position - 1')
    destroy
  end

  private

  def set_position_and_status
    self.position = match.next_available_position(player)
  end

  def set_player
    player = Player.find_by("number IS NOT NULL and number = ?", player_number)
    player = Player.create(number: player_number, name: player_name, pib_priority: player_pib_priority) if player.nil?

    if friend_name
      player_as_friend = Player.find_by(name: friend_name, player_friend_id: player&.id)
      self.player_id = player_as_friend&.id || Player.create(player_friend_id: player&.id, name: friend_name, pib_priority: false).id

      return
    end

      self.player_id = player.id
      player.update_attribute(:pib_priority, player_pib_priority) if player.pib_priority != player_pib_priority
  end

  def set_match
    self.match_id = Match.open.last&.id || Match.create(status: :open, date: Date.today)&.id
  end
end
