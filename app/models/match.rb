class Match < ApplicationRecord 
  include AASM
  has_many :player_per_matches

  validates :status, :date, presence: true

  enum status: { open: 0, closed: 1, cancelled: 2 }

  aasm column: 'status', enum: true do
    state :open
    state :closed
    state :cancelled

    event :cancel do 
      transitions from: [:open, :closed], to: :cancelled

      after do 
        player_per_matches.destroy_all
      end
    end
  end

  def next_available_position(player)
    if player.pib_priority?
      last_pib_priority_registered = player_per_matches.avaliable.joins(:player).where(player: {pib_priority: true}).last

      if last_pib_priority_registered
        update_player_per_matches_positions
        last_pib_priority_registered.position + 1
      else
        1
      end
    else
      player_per_matches.any? ? player_per_matches.last.position + 1 : 1
    end
  end

  def print_list_of_players
    return "Não existem jogadores confirmados." if player_per_matches.size == player_per_matches.not_confimed.size

    "Lista de Confirmados\n#{player_per_matches.avaliable.order(:position).map(&:list_line).join("")}"
  end

  private 

  def update_player_per_matches_positions
    player_per_matches.avaliable.joins(:player).where(player: {pib_priority: [false, nil]}).update_all("position = position + 1")
  end
end
