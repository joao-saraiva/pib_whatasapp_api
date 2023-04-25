# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should belong_to(:player).optional(true) }
  it { should have_many(:player_friends) }
  it { should validate_presence_of(:name) }

  context 'when player_friend_id is not null' do
    it 'should validate absence of number' do
      player = FactoryBot.build(:player, :inveted_friend)
      player.number = '8585'
      player.valid?

      expect(player.errors[:number]).to include('must be blank')
    end
  end

  context 'when number is not null' do
    it 'should validate absence of friend_player_id' do
      player = FactoryBot.build(:player)
      player.player_friend_id = 1
      player.valid?

      expect(player.errors[:player_friend_id]).to include('must be blank')
    end
  end
end
