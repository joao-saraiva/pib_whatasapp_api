require 'rails_helper'

RSpec.describe Match, type: :model do
  %i[date status].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should have_many(:player_per_matches) }
  it { should define_enum_for(:status).with_values([:open, :closed, :cancelled]) }

  describe "#next_available_position(player)" do
    before(:each) do 
      @match = FactoryBot.create(:match)
    end
    context "player has pib priority" do 
      context "when 10 no pib priority are queded" do 
        it "should be the first" do 
          10.times do 
            FactoryBot.create(:player_per_match, match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, :pib_priority, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(1)
        end
      end

      context "when 10 pib prioriry are queded" do
        it "should be the last" do 
          10.times do 
            FactoryBot.create(:player_per_match, :pib_priority,  match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, :pib_priority, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(11)
        end 
      end

      context "when 5 pib priority and 5 non pib priority are queded" do 
        it "should be the 6" do 
          5.times do 
            FactoryBot.create(:player_per_match, match_id: @match.id)
          end

          5.times do 
            FactoryBot.create(:player_per_match, :pib_priority,  match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, :pib_priority, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(6)
        end
      end
    end

    context "player has no pib priority " do 
      context "when 10 pib priority are queded" do 
        it "should be the 11" do 
          10.times do 
            FactoryBot.create(:player_per_match, :pib_priority, match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(11)
        end
      end

      context "when 10 no pib prioriry are queded" do 
        it "should be the 11" do 
          10.times do 
            FactoryBot.create(:player_per_match, match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(11)
        end
      end

      context "when 5 pib no prioriry and 5 pib priority are queded" do 
        it "should be the 11" do 
          5.times do 
            FactoryBot.create(:player_per_match, :pib_priority, match_id: @match.id)
          end

          5.times do 
            FactoryBot.create(:player_per_match, match_id: @match.id)
          end

          player_per_match = FactoryBot.build(:player_per_match, match_id: @match.id)
          expect(@match.next_available_position(player_per_match.player)).to eq(11)
        end
      end
    end
  end

  describe "#print_list_of_players" do
    before(:each) do 
      @match = FactoryBot.create(:match)
    end

    context "when has no player confirmed" do
      context "when has no player at all" do 
        it "should return a string saying that has no player" do 
          expect(@match.print_list_of_players).to eq("Não existem jogadores confirmados.")
        end
      end

      context "when has players but none of them are confirmed" do 
        it "should return a string saying that has no player" do 
          10.times do 
            FactoryBot.create(:player_per_match, :waiting, match_id: @match.id)
          end

          expect(@match.print_list_of_players).to eq("Não existem jogadores confirmados.")
        end
      end
    end

    context "when has player confirmed" do
      context "when has 5 players confirmed and 5 players gived_up" do 
        it "should return a string only with players that are avaliable" do 
          5.times do 
            FactoryBot.create(:player_per_match, match_id: @match.id)
          end

          5.times do 
            FactoryBot.create(:player_per_match, :gived_up, match_id: @match.id)
          end
          
          expect(@match.print_list_of_players).to eq("Lista de Confirmados\n1 - Jeff\n2 - Jeff\n3 - Jeff\n4 - Jeff\n5 - Jeff\n")
        end
      end
    end
  end
end