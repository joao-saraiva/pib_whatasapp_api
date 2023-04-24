require 'rails_helper'

RSpec.describe PlayerPerMatch, type: :model do
  it { should belong_to(:player).required(true) }
  it { should belong_to(:match).required(true) }

  it { should define_enum_for(:status).with_values([:confirmed, :waiting, :gived_up]) }


  %i[status position].each do |attribute|
    it { should validate_presence_of(attribute) }
  end

  describe "#on_waiting_list?" do
    context "when position its bigger than 24" do 
      it "should return true" do 
        player_per_match = FactoryBot.create(:player_per_match, :on_waiting_list)
        expect(player_per_match.on_waiting_list?).to be(true)
      end
    end

    context "when position its lower than 24" do 
      it "should return false" do 
        player_per_match = FactoryBot.create(:player_per_match)
        expect(player_per_match.on_waiting_list?).to be(false)
      end
    end
  end
end