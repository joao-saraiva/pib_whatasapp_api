require 'rails_helper'

RSpec.describe PlayerPerMatch, type: :model do
  it { should belong_to(:player).required(true) }
  it { should belong_to(:match).required(true) }

  it { should define_enum_for(:status).with_values([:confirmed, :waiting, :gived_up]) }


  %i[status position].each do |attribute|
    it { should validate_presence_of(attribute) }
  end

  describe "#give_up!" do
    before(:each) do 
      @match = FactoryBot.create(:match)
    end

    context "with other playes that are below the current position" do
      it "should decrease - 1 position to everyone below the current position" do
        player_per_match = FactoryBot.create(:player_per_match, match_id: @match.id)
        last_player_per_match = nil

        10.times do 
          last_player_per_match = FactoryBot.create(:player_per_match, match_id: @match.id)
        end

        original_position = @match.player_per_matches.avaliable.pluck(:position).sort
        player_per_match.give_up!

        expect(last_player_per_match.reload.position).to eq(10)
        expect(@match.player_per_matches.avaliable).to_not include(player_per_match)
        expect(player_per_match.gived_up?).to eq(true)
        expect(@match.player_per_matches.avaliable.pluck(:position).sort).to_not eq(original_position)
        expect(@match.player_per_matches.avaliable.pluck(:position).sort).to eq([1,2,3,4,5,6,7,8,9,10])
      end
    end

    context "with other players that are above the current position" do 
      it "should keep the position from all the records above" do 
        last_player_per_match = nil

        10.times do 
          last_player_per_match = FactoryBot.create(:player_per_match, match_id: @match.id)
        end

        player_per_match = FactoryBot.create(:player_per_match, match_id: @match.id)
        original_position = @match.player_per_matches.avaliable.pluck(:position).sort
        player_per_match.give_up!

        expect(last_player_per_match.reload.position).to eq(10)
        expect(player_per_match.gived_up?).to eq(true)
        expect(@match.player_per_matches.avaliable).to_not include(player_per_match)
        expect(@match.player_per_matches.avaliable.pluck(:position).sort).to_not eq(original_position)
        expect(@match.player_per_matches.avaliable.pluck(:position).sort).to eq([1,2,3,4,5,6,7,8,9,10])
      end
    end
  end

  describe "#confirm!" do
    it "should change status from waiting to confirmed" do 
      player_per_match = FactoryBot.create(:player_per_match, :waiting)

      expect(player_per_match.waiting?).to be(true)
      player_per_match.confirm!

      expect(player_per_match.confirmed?).to be(true)
    end
  end
end 