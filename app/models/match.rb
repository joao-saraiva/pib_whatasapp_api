# frozen_string_literal: true

class Match < ApplicationRecord
  include AASM
  has_many :player_per_matches, dependent: :destroy

  validates :status, :date, presence: true

  enum status: { open: 0, cancelled: 1 }

  aasm column: 'status', enum: true do
    state :open
    state :cancelled

    event :cancel do 
      transitions from: [:open, :closed], to: :cancelled
    end
  end

  def next_available_position(player)
    if player.pib_priority?
      last_pib_priority_registered = player_per_matches.pib_priority.order(:position).last
      update_player_per_matches_positions

      if last_pib_priority_registered
        last_pib_priority_registered.position + 1
      else
        1
      end
    else
      player_per_matches.any? ? player_per_matches.order(:position).last.position + 1 : 1
    end
  end

  def print_list_of_players
    return 'Não existem jogadores inscritos.' if player_per_matches.size.zero?

    "Lista de Confirmados\n#{player_per_matches.order(:position).map(&:list_line).join('')}"
  end

  private

  def update_player_per_matches_positions
    player_per_matches.non_pib_priority.update_all('position = position + 1')
  end
end
