require 'rails_helper'

RSpec.describe Match, type: :model do
  %i[date status].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should have_many(:player_per_matches) }
  it { should define_enum_for(:status).with_values([:open, :closed, :cancelled]) }

  describe "#next_avaliable_position(player)" do
    context "player has pib priority" do 
      match = FactoryBot.create(:match)

      context "when 10 no pib priority are queded" do 
        it "should be the first" do 
          10.times do 
            FactoryBot.create(:player_per_match, match_id: match.id)
          end

          player_per_match = FactoryBot.create(:player_per_match, :pib_priority, match_id: match.id)

          expect(match.next_avaliable_position(player.match)).to be(1)
        end
      end

      context "when 10 pib prioriry are queded" do
        it "should be the last" do 
          10.times do 
            FactoryBot.create(:player_per_match, :pib_priority,  match_id: match.id)
          end

          player_per_match = FactoryBot.create(:player_per_match, :pib_priority, match_id: match.id)
          expect(match.next_avaliable_position(player.match)).to be(11)
        end 
      end

      context "when 5 pib priority and 5 non pib priority are queded" do 
        it "should be the 6" do 
          5.times do 
            FactoryBot.create(:player_per_match, match_id: match.id)
          end

          5.times do 
            FactoryBot.create(:player_per_match, :pib_priority,  match_id: match.id)
          end

          player_per_match = FactoryBot.create(:player_per_match, :pib_priority, match_id: match.id)
          expect(match.next_avaliable_position(player.match)).to be(6)
        end
      end
    end

    context "player has no pib priority " do 
    end
  end
end