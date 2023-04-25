# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :player, class_name: 'Player', optional: true,
                      foreign_key: 'player_friend_id'
  has_many :player_friends, class_name: 'Player',
                            foreign_key: 'player_friend_id', dependent: :destroy

  validates :name, presence: true
  validates :number, absence: true, if: proc { player_friend_id }
  validates :player_friend_id, absence: true, if: proc { number }
  validates :number, presence: true, if: proc { player_friend_id.nil? }
  validates :player_friend_id, presence: true, if: proc { number.nil? }
end
